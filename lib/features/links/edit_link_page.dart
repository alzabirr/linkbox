import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/models/link_item.dart';
import '../../core/providers.dart';
import '../../core/services/image_store.dart';
import '../../core/services/metadata_parser.dart';
import '../../core/services/metadata_service.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_button.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/icon_box.dart';
import '../../core/widgets/link_picture.dart';
import '../../core/widgets/scene_art.dart';
import '../../l10n/app_localizations.dart';
import '../collections/move_sheet.dart';
import 'links_providers.dart';

/// Edit title, summary and picture; fetch the preview again (08).
class EditLinkPage extends ConsumerStatefulWidget {
  const EditLinkPage({super.key, required this.linkId});

  final int linkId;

  @override
  ConsumerState<EditLinkPage> createState() => _EditLinkPageState();
}

class _EditLinkPageState extends ConsumerState<EditLinkPage> {
  final _title = TextEditingController();
  final _summary = TextEditingController();
  String? _imageUrl;
  String? _imageFile;
  bool _loaded = false;
  bool _fetching = false;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _summary.dispose();
    super.dispose();
  }

  void _load(LinkItem link) {
    if (_loaded) return;
    _loaded = true;
    _title.text = link.title ?? '';
    _summary.text = link.description ?? '';
    _imageUrl = link.imageUrl;
    _imageFile = link.customImagePath;
  }

  Future<void> _changeImage() async {
    final path = await const ImageStore().pickForLink(widget.linkId);
    if (path != null) setState(() => _imageFile = path);
  }

  Future<void> _fetchAgain(LinkItem link) async {
    setState(() => _fetching = true);
    try {
      final meta = await ref.read(metadataServiceProvider).fetch(link.url);
      if (!mounted) return;
      setState(() {
        if (meta.title != null) _title.text = meta.title!;
        if (meta.description != null) _summary.text = meta.description!;
        _imageUrl = meta.imageUrl ?? _imageUrl;
        _imageFile = null; // show the fresh page image
      });
    } on MetadataException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).fetchFailed)));
    } finally {
      if (mounted) setState(() => _fetching = false);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref.read(linkRepositoryProvider).updateDetails(
          widget.linkId,
          title: _title.text,
          description: _summary.text,
          imageUrl: _imageUrl,
          customImagePath: _imageFile,
        );
    if (mounted) Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final link = ref.watch(linkProvider(widget.linkId)).value;
    if (link == null) return const Scaffold();
    _load(link);
    final cols = ref.watch(collectionsProvider).value ?? const [];
    String collection = l.noCollection;
    Color collectionColor = t.surface;
    for (final c in cols) {
      if (c.id == link.collectionId) {
        collection = c.name;
        collectionColor = c.color;
      }
    }
    final onCollection =
        collectionColor == t.surface ? t.text : AppColors.ink;

    Widget label(String text, [Widget? trailing]) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Expanded(
                child: Text(text,
                    style: AppText.body(14,
                        weight: FontWeight.w700, color: t.text)),
              ),
              ?trailing,
            ],
          ),
        );

    InputDecoration field(double vertical) => InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 14, vertical: vertical),
        );

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
              child: Row(
                children: [
                  IconBox(
                    icon: AppIcons.back,
                    tooltip: l.back,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(l.editTitle,
                          style: AppText.display(26, color: t.text)),
                    ),
                  ),
                  BoldButton(
                    label: l.save,
                    size: BoldButtonSize.header,
                    shadow: true,
                    onPressed: _saving ? null : _save,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 18, 32),
                children: [
                  Container(
                    height: 176,
                    clipBehavior: Clip.antiAlias,
                    decoration: boldBox(
                      fill: AppColors.sky,
                      outline: t.outline,
                      radius: AppShape.rSection,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        LinkPicture(
                          imageUrl: _imageUrl,
                          filePath: _imageFile,
                          fallback:
                              SceneArt(seed: link.url, showBadge: false),
                        ),
                        Positioned(
                          left: 10,
                          bottom: 10,
                          child: Row(
                            children: [
                              _SmallButton(
                                icon: AppIcons.image,
                                label: l.changeImage,
                                fill: AppColors.white,
                                onTap: _changeImage,
                              ),
                              const SizedBox(width: 8),
                              _SmallButton(
                                icon: AppIcons.retry,
                                label: l.fetchAgain,
                                fill: AppColors.sun,
                                busy: _fetching,
                                onTap: () => _fetchAgain(link),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  ValueListenableBuilder(
                    valueListenable: _title,
                    builder: (context, value, _) => label(
                      l.titleLabel,
                      Text(
                          l.charCount(
                              value.text.length, MetadataParser.maxTitle),
                          style: AppText.body(12,
                              weight: FontWeight.w600, color: t.muted)),
                    ),
                  ),
                  Container(
                    decoration: boldBox(
                      fill: t.surface,
                      outline: t.outline,
                      radius: AppShape.rControlSm,
                      shadow: t.shadowOf(AppShadows.offSm),
                    ),
                    constraints: const BoxConstraints(minHeight: 54),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: _title,
                      maxLines: null,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                            MetadataParser.maxTitle),
                      ],
                      cursorColor: t.text,
                      style: AppText.body(15,
                          weight: FontWeight.w600, color: t.text),
                      decoration: field(15),
                    ),
                  ),
                  const SizedBox(height: 18),
                  label(l.summaryLabel),
                  Container(
                    decoration: boldBox(
                      fill: t.surface,
                      outline: t.outline,
                      radius: AppShape.rControlSm,
                    ),
                    constraints: const BoxConstraints(minHeight: 96),
                    child: TextField(
                      controller: _summary,
                      maxLines: null,
                      minLines: 3,
                      cursorColor: t.text,
                      style: AppText.body(14, height: 1.45, color: t.text),
                      decoration: field(12),
                    ),
                  ),
                  const SizedBox(height: 18),
                  label(l.linkLabel),
                  Container(
                    constraints: const BoxConstraints(minHeight: 50),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: boldBox(
                      fill: t.sand,
                      outline: t.outline,
                      radius: AppShape.rControlSm,
                    ),
                    child: SelectableText(link.url,
                        style: AppText.body(14, color: t.text)),
                  ),
                  const SizedBox(height: 18),
                  label(l.collectionLabel),
                  BoldCard(
                    height: 54,
                    fill: collectionColor,
                    radius: AppShape.rControlSm,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    semanticLabel: '${l.collectionLabel}: $collection',
                    onTap: () => showMoveSheet(context,
                        linkIds: [link.id],
                        currentCollectionId: link.collectionId),
                    child: Row(
                      children: [
                        AppIcon(AppIcons.folder,
                            size: 20, color: onCollection),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(collection,
                              style: AppText.body(15,
                                  weight: FontWeight.w700,
                                  color: onCollection)),
                        ),
                        AppIcon(AppIcons.chevronRight,
                            size: 20, color: onCollection),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 40 high button on the picture (Change image / Fetch again).
class _SmallButton extends StatelessWidget {
  const _SmallButton({
    required this.icon,
    required this.label,
    required this.fill,
    required this.onTap,
    this.busy = false,
  });

  final AppIconData icon;
  final String label;
  final Color fill;
  final VoidCallback onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return BoldCard(
      height: 40,
      fill: fill,
      outline: AppColors.ink,
      radius: AppShape.rTiny,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      onTap: busy ? null : onTap,
      semanticLabel: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          busy
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.4, color: AppColors.ink),
                )
              : AppIcon(icon, size: 16, color: AppColors.ink),
          const SizedBox(width: 6),
          Text(label,
              style: AppText.body(13,
                  weight: FontWeight.w700, color: AppColors.ink)),
        ],
      ),
    );
  }
}
