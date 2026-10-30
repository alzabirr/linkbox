import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/models/link_item.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_button.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/bold_sheet.dart';
import '../../core/widgets/link_picture.dart';
import '../../core/widgets/scene_art.dart';
import '../../l10n/app_localizations.dart';
import '../collections/move_sheet.dart';
import 'delete_dialog.dart';
import 'link_actions.dart';
import 'links_providers.dart';

/// Opens Quick look (04) for a link.
Future<void> showQuickLook(BuildContext context, int linkId) =>
    showBoldSheet<void>(context, builder: (_) => QuickLookSheet(linkId: linkId));

class QuickLookSheet extends ConsumerStatefulWidget {
  const QuickLookSheet({super.key, required this.linkId});

  final int linkId;

  @override
  ConsumerState<QuickLookSheet> createState() => _QuickLookSheetState();
}

class _QuickLookSheetState extends ConsumerState<QuickLookSheet> {
  bool _copied = false;

  Future<void> _copy(LinkItem link) async {
    await LinkActions.copy(context, link, toast: false);
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final linkId = widget.linkId;
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final link = ref.watch(linkProvider(linkId)).value;
    if (link == null) return const SizedBox(height: 120);
    final cols = ref.watch(collectionsProvider).value ?? const [];
    String? collection;
    for (final c in cols) {
      if (c.id == link.collectionId) collection = c.name;
    }
    final colors = SceneColors.of(link.url);
    final nav = Navigator.of(context);
    final router = GoRouter.of(context);

    Widget textButton(AppIconData icon, String label, VoidCallback onTap,
            {Color? color}) =>
        Expanded(
          child: Semantics(
            button: true,
            label: label,
            onTap: onTap,
            excludeSemantics: true,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: SizedBox(
                height: 46,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppIcon(icon, size: 18, color: color ?? t.text),
                    const SizedBox(width: 6),
                    Text(label,
                        style: AppText.body(14,
                            weight: FontWeight.w700, color: color ?? t.text)),
                  ],
                ),
              ),
            ),
          ),
        );

    return BoldSheet(
      padding: const EdgeInsets.fromLTRB(18, 12, 20, 26),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 5, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // The collectible card.
            BoldCard(
              fill: colors.frame,
              radius: 24,
              shadow: AppShadows.offLg,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text((collection ?? '').toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.display(15,
                                  letterSpacing: 0.5, color: AppColors.ink)),
                        ),
                        Text(l.linkNumber(link.id.toString().padLeft(3, '0')),
                            style: AppText.display(15, color: AppColors.ink)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 168,
                    clipBehavior: Clip.antiAlias,
                    decoration: boldBox(
                      fill: colors.sky,
                      outline: AppColors.ink,
                      radius: AppShape.rControlSm,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        LinkPicture(
                          imageUrl: link.imageUrl,
                          filePath: link.customImagePath,
                          fallback: SceneArt(seed: link.url, showBadge: false),
                        ),
                        if (link.kind == LinkKind.video)
                          Center(
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.ink, width: 3),
                                boxShadow: AppShadows.hard(
                                    AppShadows.offSm, AppColors.ink),
                              ),
                              child: const Center(
                                child: AppIcon(AppIcons.playBig,
                                    size: 26, color: AppColors.ink),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(link.displayTitle,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.display(22,
                                height: 1.15, color: AppColors.ink)),
                        if (link.description != null) ...[
                          const SizedBox(height: 6),
                          Text(link.description!,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.body(14,
                                  height: 1.5, color: AppColors.ink)),
                        ],
                        const SizedBox(height: 6),
                        Text('${link.domain} · ${savedAgo(context, link.createdAt)}',
                            style: AppText.body(12,
                                weight: FontWeight.w600, color: AppColors.ink)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 13,
                  child: BoldButton(
                    label: l.open,
                    icon: AppIcons.external,
                    size: BoldButtonSize.overlayLarge,
                    expand: true,
                    onPressed: () => LinkActions.open(context, link),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 10,
                  child: BoldButton(
                    label: _copied ? l.copied : l.copy,
                    icon: _copied ? AppIcons.check : AppIcons.copy,
                    kind: BoldButtonKind.secondary,
                    size: BoldButtonSize.overlayLarge,
                    weight: FontWeight.w700,
                    expand: true,
                    onPressed: () => _copy(link),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 10,
                  child: BoldButton(
                    label: l.share,
                    icon: AppIcons.share,
                    kind: BoldButtonKind.secondary,
                    size: BoldButtonSize.overlayLarge,
                    weight: FontWeight.w700,
                    expand: true,
                    onPressed: () => LinkActions.share(link),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                textButton(AppIcons.edit, l.edit, () {
                  nav.pop();
                  router.push('/link/${link.id}/edit');
                }),
                const SizedBox(width: 8),
                textButton(AppIcons.moveTo, l.move, () => showMoveSheet(context,
                    linkIds: [link.id], currentCollectionId: link.collectionId)),
                const SizedBox(width: 8),
                textButton(AppIcons.trash, l.delete, () async {
                  final undo = ref.read(undoDeleteProvider.notifier);
                  if (await showDeleteDialog(context, count: 1)) {
                    nav.pop();
                    await undo.delete([link.id]);
                  }
                }, color: t.dangerText),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
