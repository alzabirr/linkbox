import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/models/collection_item.dart';
import '../../core/utils/url_normalizer.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_button.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/bold_chip.dart';
import '../../core/widgets/bold_sheet.dart';
import '../../core/widgets/scene_art.dart';
import '../../l10n/app_localizations.dart';
import 'add_link_controller.dart';
import 'links_providers.dart';

/// Opens the Add link sheet (06).
Future<void> showAddLinkSheet(BuildContext context, {int? collectionId}) =>
    showBoldSheet<void>(
      context,
      tall: true,
      builder: (_) => AddLinkSheet(collectionId: collectionId),
    );

class AddLinkSheet extends ConsumerStatefulWidget {
  const AddLinkSheet({super.key, this.collectionId});

  /// Pre-selected collection (e.g. "Add to Design" in 19).
  final int? collectionId;

  @override
  ConsumerState<AddLinkSheet> createState() => _AddLinkSheetState();
}

class _AddLinkSheetState extends ConsumerState<AddLinkSheet> {
  final _field = TextEditingController();

  AddLinkControllerProvider get _provider =>
      addLinkControllerProvider(widget.collectionId);

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text == null || text.isEmpty) return;
    final url = UrlUtils.extractFirst(text) ?? text;
    _field.text = url;
    _field.selection = TextSelection.collapsed(offset: url.length);
    ref.read(_provider.notifier).setUrl(url);
  }

  Future<void> _save() async {
    final saved = await ref.read(_provider.notifier).save();
    if (saved && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final state = ref.watch(_provider);
    final collections = ref.watch(collectionsProvider).value ?? const [];

    final error = switch (state.status) {
      AddLinkStatus.invalid => l.invalidLink,
      AddLinkStatus.duplicate => l.alreadySaved,
      _ => null,
    };

    return BoldSheet(
      title: l.addLinkTitle,
      closeLabel: l.close,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              // Clip so content never draws under the Save button; the
              // padding leaves room for the 3 px field shadow.
              padding: const EdgeInsets.only(right: 4, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Label(l.linkLabel),
                  const SizedBox(height: 8),
                  _LinkField(
                    controller: _field,
                    hint: l.linkFieldHint,
                    pasteLabel: l.paste,
                    onChanged: ref.read(_provider.notifier).setUrl,
                    onPaste: _paste,
                    onSubmitted: (_) => _save(),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 8),
                    Text(error,
                        style: AppText.body(13,
                            weight: FontWeight.w600, color: t.dangerText)),
                  ],
                  if (state.showPreview) ...[
                    const SizedBox(height: 18),
                    _Label(l.previewLabel),
                    const SizedBox(height: 8),
                    _Preview(state: state),
                    const SizedBox(height: 8),
                    _StatusLine(state: state),
                  ],
                  const SizedBox(height: 18),
                  _Label(l.collectionLabel),
                  const SizedBox(height: 10),
                  _CollectionPicker(
                    collections: collections,
                    selected: state.collectionId,
                    noneLabel: l.chipNone,
                    onSelect: ref.read(_provider.notifier).selectCollection,
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
          BoldButton(
            label: l.saveLink,
            expand: true,
            onPressed: state.canSave ? _save : null,
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(text,
      style: AppText.body(14,
          weight: FontWeight.w700, color: context.tokens.text));
}

/// 58 high field with a sun "Paste" button (06).
class _LinkField extends StatelessWidget {
  const _LinkField({
    required this.controller,
    required this.hint,
    required this.pasteLabel,
    required this.onChanged,
    required this.onPaste,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final String pasteLabel;
  final ValueChanged<String> onChanged;
  final VoidCallback onPaste;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      height: 58,
      padding: const EdgeInsets.fromLTRB(16, 0, 7, 0),
      decoration: boldBox(
        fill: t.surface,
        outline: t.outline,
        radius: AppShape.rControl,
        shadow: t.shadowOf(AppShadows.offSm),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              keyboardType: TextInputType.url,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.done,
              cursorColor: t.text,
              style: AppText.body(15, color: t.text),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: AppText.body(15, color: t.muted),
              ),
            ),
          ),
          const SizedBox(width: 8),
          BoldCard(
            height: 40,
            fill: AppColors.sun,
            outline: AppColors.ink,
            stroke: AppShape.strokeThin,
            radius: AppShape.rTiny,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            onTap: onPaste,
            semanticLabel: pasteLabel,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppIcon(AppIcons.paste, size: 16, color: AppColors.ink),
                const SizedBox(width: 6),
                Text(pasteLabel,
                    style: AppText.body(13,
                        weight: FontWeight.w800, color: AppColors.ink)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Sky box: thumb, title, 2-line summary, domain.
class _Preview extends StatelessWidget {
  const _Preview({required this.state});

  final AddLinkState state;

  @override
  Widget build(BuildContext context) {
    final meta = state.meta;
    final loading = state.status == AddLinkStatus.loading;
    final scene = SceneArt(seed: state.url, showBadge: false);
    final title = meta?.title ??
        state.url.replaceFirst(RegExp(r'^https?://(www\.)?'), '');

    return BoldCard(
      fill: AppColors.sky,
      outline: AppColors.ink,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 92,
            height: 92,
            clipBehavior: Clip.antiAlias,
            decoration: boldBox(
              fill: AppColors.cream,
              outline: AppColors.ink,
              radius: AppShape.rSmall,
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(AppShape.rSmall - AppShape.stroke),
              child: loading
                  ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            strokeWidth: 3, color: AppColors.ink),
                      ),
                    )
                  : meta?.imageUrl == null
                      ? scene
                      : CachedNetworkImage(
                          imageUrl: meta!.imageUrl!,
                          fit: BoxFit.cover,
                          fadeInDuration: AppMotion.select,
                fadeOutDuration: Duration.zero,
                placeholder: (_, _) => const ColoredBox(color: AppColors.sand),
                          errorWidget: (_, _, _) => scene,
                        ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.display(17,
                      height: 1.15, color: AppColors.ink),
                ),
                if (meta?.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    meta!.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body(13,
                        height: 1.4, color: AppColors.ink),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  state.domain,
                  style: AppText.body(12,
                      weight: FontWeight.w700, color: AppColors.ink),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "Found the title…" / "Getting the preview…" / failed / offline.
class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.state});

  final AddLinkState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final found = state.status == AddLinkStatus.found;
    final text = switch (state.status) {
      AddLinkStatus.found => l.previewFound,
      AddLinkStatus.loading => l.previewLoading,
      AddLinkStatus.offline => l.previewOffline,
      _ => l.previewFailed,
    };
    final color = found
        ? (t.isDark ? AppColors.mint : AppColors.successText)
        : t.muted;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (found) ...[
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.mint,
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.ink, width: AppShape.strokeThin),
            ),
            child: const Center(
              child: AppIcon(AppIcons.check,
                  size: 11, strokeWidth: 4, color: AppColors.ink),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(text,
              style:
                  AppText.body(13, weight: FontWeight.w600, color: color)),
        ),
      ],
    );
  }
}

/// None + collections. Selected = ink with a check (06).
class _CollectionPicker extends StatelessWidget {
  const _CollectionPicker({
    required this.collections,
    required this.selected,
    required this.noneLabel,
    required this.onSelect,
  });

  final List<CollectionItem> collections;
  final int? selected;
  final String noneLabel;
  final ValueChanged<int?> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        BoldChip(
          label: noneLabel,
          height: 40,
          selected: selected == null,
          showCheck: true,
          onTap: () => onSelect(null),
        ),
        for (final c in collections)
          BoldChip(
            label: c.name,
            color: c.color,
            height: 40,
            selected: selected == c.id,
            showCheck: true,
            onTap: () => onSelect(c.id),
          ),
      ],
    );
  }
}
