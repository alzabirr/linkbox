import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/models/link_item.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_card.dart';
import '../../l10n/app_localizations.dart';
import '../collections/move_sheet.dart';
import 'link_actions.dart';
import 'links_providers.dart';

/// Ink pill that replaces the header while selecting (10).
class SelectionTopBar extends ConsumerWidget {
  const SelectionTopBar({super.key, required this.visible});

  /// The links on screen, for "Select all".
  final List<LinkItem> visible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final selected = ref.watch(selectionProvider);
    final notifier = ref.read(selectionProvider.notifier);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(AppShape.rCard),
          border: t.isDark
              ? Border.all(color: t.outline, width: AppShape.stroke)
              : null,
        ),
        child: Row(
          children: [
            Tooltip(
              message: l.cancelSelection,
              child: BoldCard(
                width: 44,
                height: 44,
                fill: Colors.transparent,
                outline: AppColors.white,
                radius: AppShape.rSmall,
                onTap: notifier.clear,
                semanticLabel: l.cancelSelection,
                child: const Center(
                  child: AppIcon(AppIcons.close,
                      size: 20, color: AppColors.white),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Semantics(
                liveRegion: true,
                child: Text(l.selectedCount(selected.length),
                    style: AppText.display(22, color: AppColors.white)),
              ),
            ),
            BoldCard(
              height: 44,
              fill: Colors.transparent,
              outline: AppColors.white,
              radius: AppShape.rSmall,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              onTap: () => notifier.selectAll(visible.map((e) => e.id)),
              semanticLabel: l.selectAll,
              child: Center(
                widthFactor: 1,
                child: Text(l.selectAll,
                    style: AppText.body(14,
                        weight: FontWeight.w700, color: AppColors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// White toolbar with Move · Share · Delete (10).
class SelectionToolbar extends ConsumerWidget {
  const SelectionToolbar({super.key, required this.visible});

  final List<LinkItem> visible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final ids = ref.watch(selectionProvider).toList();
    final notifier = ref.read(selectionProvider.notifier);

    Future<void> move() async {
      final moved = await showMoveSheet(context, linkIds: ids);
      if (moved) notifier.clear();
    }

    Future<void> share() async {
      final urls = [
        for (final link in visible)
          if (ids.contains(link.id)) link.url,
      ];
      await SharePlus.instance.share(ShareParams(text: urls.join('\n')));
    }

    Future<void> delete() async {
      final undo = ref.read(undoDeleteProvider.notifier);
      if (await LinkActions.delete(context, undo, ids)) notifier.clear();
    }

    Widget action(AppIconData icon, String label, Color fill, VoidCallback f) =>
        Expanded(
          child: BoldCard(
            height: 60,
            fill: fill,
            outline: AppColors.ink,
            radius: AppShape.rControlSm,
            onTap: ids.isEmpty ? null : f,
            semanticLabel: label,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppIcon(icon, size: 20, color: AppColors.ink),
                const SizedBox(height: 2),
                Text(label,
                    style: AppText.body(13,
                        weight: FontWeight.w700, color: AppColors.ink)),
              ],
            ),
          ),
        );

    return BoldCard(
      radius: 24,
      shadow: AppShadows.offMd,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          action(AppIcons.moveTo, l.move, AppColors.sky, move),
          const SizedBox(width: 8),
          action(AppIcons.share, l.share, AppColors.mint, share),
          const SizedBox(width: 8),
          action(AppIcons.trash, l.delete, AppColors.danger, delete),
        ],
      ),
    );
  }
}
