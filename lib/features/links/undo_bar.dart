import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_card.dart';
import '../../l10n/app_localizations.dart';
import 'links_providers.dart';

/// "Deleted 3 links · Undo" with a line that shrinks over 5 s (29).
class UndoBar extends ConsumerWidget {
  const UndoBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(undoDeleteProvider);
    final reduce = AppMotion.reduce(context);
    return AnimatedSwitcher(
      duration: reduce ? AppMotion.reduced : AppMotion.pop,
      switchInCurve: reduce ? Curves.linear : Curves.easeOutBack,
      transitionBuilder: (child, anim) => reduce
          ? FadeTransition(opacity: anim, child: child)
          : SlideTransition(
              position: Tween(begin: const Offset(0, 1.6), end: Offset.zero)
                  .animate(anim),
              child: child,
            ),
      child: pending == null
          ? const SizedBox.shrink()
          : _Bar(key: ObjectKey(pending), pending: pending),
    );
  }
}

class _Bar extends ConsumerWidget {
  const _Bar({super.key, required this.pending});

  final PendingDelete pending;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    return Semantics(
      liveRegion: true,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(AppShape.rCard),
          border: t.isDark
              ? Border.all(color: t.outline, width: AppShape.stroke)
              : null,
          boxShadow: AppShadows.hard(AppShadows.offMd, t.accent),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: AppIcon(AppIcons.trash,
                          size: 16, strokeWidth: 2.6, color: AppColors.ink),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(l.deletedLinks(pending.ids.length),
                        style: AppText.body(15,
                            weight: FontWeight.w600, color: AppColors.white)),
                  ),
                  BoldCard(
                    height: 44,
                    fill: AppColors.sun,
                    outline: AppColors.white,
                    radius: AppShape.rSmall,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    onTap: ref.read(undoDeleteProvider.notifier).undo,
                    semanticLabel: l.undo,
                    child: Center(
                      widthFactor: 1,
                      child: Text(l.undo,
                          style: AppText.body(15,
                              weight: FontWeight.w800, color: AppColors.ink)),
                    ),
                  ),
                ],
              ),
            ),
            // Progress line: full → empty over the Undo window.
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 1, end: 0),
              duration: UndoDelete.window -
                  DateTime.now().difference(pending.startedAt),
              builder: (context, v, _) => Container(
                height: 5,
                color: AppColors.inkTrack,
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: v.clamp(0, 1),
                  heightFactor: 1,
                  child: const ColoredBox(color: AppColors.sun),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
