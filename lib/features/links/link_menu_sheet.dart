import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/models/link_item.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/bold_sheet.dart';
import '../../core/widgets/scene_art.dart';
import '../../l10n/app_localizations.dart';
import '../collections/move_sheet.dart';
import 'link_actions.dart';
import 'links_providers.dart';

/// ⋮ on a list row → link options (21).
Future<void> showLinkMenu(BuildContext context, LinkItem link) =>
    showBoldSheet<void>(context, builder: (_) => _LinkMenu(link: link));

class _LinkMenu extends ConsumerWidget {
  const _LinkMenu({required this.link});

  final LinkItem link;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final cols = ref.watch(collectionsProvider).value ?? const [];
    String? collection;
    for (final c in cols) {
      if (c.id == link.collectionId) collection = c.name;
    }
    final nav = Navigator.of(context);
    // Actions that leave the sheet close it first, using the page's context.
    final page = Navigator.of(context).context;
    // Read now: this sheet (and its ref) is gone when the dialog answers.
    final undo = ref.read(undoDeleteProvider.notifier);

    Widget row(AppIconData icon, Color bg, String label, VoidCallback onTap,
            {Color? color}) =>
        Semantics(
          button: true,
          label: label,
          onTap: onTap,
          excludeSemantics: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: boldBox(
                        fill: bg,
                        outline: AppColors.ink,
                        radius: AppShape.rTiny,
                      ),
                      child: Center(
                        child: AppIcon(icon, size: 19, color: AppColors.ink),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(label,
                        style: AppText.body(16,
                            weight: FontWeight.w700, color: color ?? t.text)),
                  ],
                ),
              ),
            ),
          ),
        );

    return BoldSheet(
      padding: const EdgeInsets.fromLTRB(16, 12, 18, 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BoldCard(
              fill: AppColors.sun,
              outline: t.outline,
              radius: AppShape.rControl,
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: boldBox(
                      fill: AppColors.white,
                      outline: AppColors.ink,
                      radius: AppShape.rThumb,
                    ),
                    child: Center(
                      child: AppIcon(
                          link.kind == LinkKind.video
                              ? AppIcons.play
                              : AppIcons.lines,
                          size: 20,
                          color: AppColors.ink),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(link.displayTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.body(15,
                                weight: FontWeight.w800, color: AppColors.ink)),
                        const SizedBox(height: 2),
                        Text(
                            collection == null
                                ? link.domain
                                : l.linkSubtitle(link.domain, collection),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.body(12,
                                weight: FontWeight.w600, color: AppColors.ink)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            row(AppIcons.external, AppColors.sky, l.openInBrowser, () {
              nav.pop();
              LinkActions.open(page, link);
            }),
            const SizedBox(height: 8),
            row(AppIcons.copy, AppColors.white, l.copyLink, () {
              nav.pop();
              LinkActions.copy(page, link);
            }),
            const SizedBox(height: 8),
            row(AppIcons.shareUp, AppColors.mint, l.share, () {
              nav.pop();
              LinkActions.share(link);
            }),
            const SizedBox(height: 8),
            row(AppIcons.edit, AppColors.white, l.edit, () {
              nav.pop();
              page.push('/link/${link.id}/edit');
            }),
            const SizedBox(height: 8),
            row(AppIcons.moveTo, AppColors.grape, l.moveToCollection, () {
              nav.pop();
              showMoveSheet(page,
                  linkIds: [link.id], currentCollectionId: link.collectionId);
            }),
            const SizedBox(height: 8),
            row(AppIcons.selectMore, AppColors.white, l.selectMore, () {
              nav.pop();
              ref.read(selectionProvider.notifier).start(link.id);
            }),
            const SizedBox(height: 8),
            row(AppIcons.trash, AppColors.danger, l.delete, () {
              nav.pop();
              LinkActions.delete(page, undo, [link.id]);
            }, color: t.dangerText),
          ],
        ),
      ),
    );
  }
}
