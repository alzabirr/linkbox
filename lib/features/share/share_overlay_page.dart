import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/models/collection_item.dart';
import '../../core/models/link_item.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_button.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/mascot.dart';
import '../../core/widgets/scene_art.dart';
import '../../l10n/app_localizations.dart';
import '../collections/move_sheet.dart';
import '../links/links_providers.dart';
import 'share_controller.dart';

/// Transparent page shown over the app the user shared from (07, 22).
class ShareOverlayPage extends ConsumerStatefulWidget {
  const ShareOverlayPage({super.key});

  @override
  ConsumerState<ShareOverlayPage> createState() => _ShareOverlayPageState();
}

class _ShareOverlayPageState extends ConsumerState<ShareOverlayPage> {
  static const _autoClose = Duration(seconds: 4);
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _close() {
    _timer?.cancel();
    ref.read(shareChannelProvider).close();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(_autoClose, _close);
  }

  Future<void> _changeCollection(LinkItem link) async {
    _timer?.cancel();
    final moved = await showMoveSheet(context,
        linkIds: [link.id], currentCollectionId: link.collectionId);
    if (moved) await ref.read(shareControllerProvider.notifier).refresh();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shareControllerProvider);
    ref.listen(shareControllerProvider, (prev, next) {
      if (next is ShareSaved && prev is! ShareSaved) _startTimer();
      if (next is ShareNoLink) _startTimer();
    });

    final Widget? card = switch (state) {
      ShareLoading() => null,
      ShareNoLink() => _MessageCard(onDone: _close),
      ShareSaved(:final link) => _SavedCard(
          link: link,
          onDone: _close,
          onChangeCollection: () => _changeCollection(link),
        ),
      ShareDuplicate(:final existing) => _DuplicateCard(
          link: existing,
          onSaveCopy: ref.read(shareControllerProvider.notifier).saveCopy,
          onOpen: () =>
              ref.read(shareChannelProvider).openInApp(existing.id),
        ),
    };

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _close();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _close,
                child: ColoredBox(
                  color: AppColors.black
                      .withValues(alpha: state is ShareDuplicate ? 0.35 : 0.3),
                ),
              ),
            ),
            if (card != null)
              Positioned(
                left: 12,
                right: 14,
                bottom: 20 + MediaQuery.viewPaddingOf(context).bottom,
                child: _SlideUp(
                  key: ValueKey(state.runtimeType),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (state is ShareSaved) const _Confetti(),
                      card,
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Slide up with a small overshoot (320 ms); a short fade if animations
/// are reduced.
class _SlideUp extends StatelessWidget {
  const _SlideUp({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final reduce = AppMotion.reduce(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: reduce ? AppMotion.reduced : AppMotion.pop,
      curve: reduce ? Curves.linear : Curves.easeOutBack,
      child: child,
      builder: (context, v, child) => reduce
          ? Opacity(opacity: v.clamp(0, 1), child: child)
          : FractionalTranslation(
              translation: Offset(0, (1 - v) * 1.2), child: child),
    );
  }
}

/// Paper card with outline, radius 28 and a 5 px shadow.
class _OverlayCard extends StatelessWidget {
  const _OverlayCard({required this.child, required this.padding});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return BoldCard(
      fill: t.background,
      radius: AppShape.rSheet,
      shadow: AppShadows.offLg,
      padding: padding,
      child: child,
    );
  }
}

String? _collectionName(List<CollectionItem> cols, int? id) {
  for (final c in cols) {
    if (c.id == id) return c.name;
  }
  return null;
}

class _SavedCard extends ConsumerWidget {
  const _SavedCard({
    required this.link,
    required this.onDone,
    required this.onChangeCollection,
  });

  final LinkItem link;
  final VoidCallback onDone;
  final VoidCallback onChangeCollection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final cols = ref.watch(collectionsProvider).value ?? const [];
    final name = _collectionName(cols, link.collectionId);

    return Semantics(
      liveRegion: true,
      child: _OverlayCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Mascot(MascotMood.cheer, size: 74),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.savedTitle,
                          style:
                              AppText.display(30, height: 1, color: t.text)),
                      const SizedBox(height: 4),
                      Text(link.displayTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.body(14,
                              weight: FontWeight.w600, color: t.text)),
                      const SizedBox(height: 4),
                      Text(
                        name == null
                            ? link.domain
                            : l.savedMeta(link.domain, name),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.body(12,
                            weight: FontWeight.w600, color: t.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  flex: 12,
                  child: BoldButton(
                    label: l.changeCollection,
                    kind: BoldButtonKind.secondary,
                    size: BoldButtonSize.overlay,
                    weight: FontWeight.w700,
                    expand: true,
                    onPressed: onChangeCollection,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 10,
                  child: BoldButton(
                    label: l.done,
                    size: BoldButtonSize.overlay,
                    expand: true,
                    onPressed: onDone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(l.closesSoon,
                textAlign: TextAlign.center,
                style: AppText.body(12,
                    weight: FontWeight.w600, color: t.muted)),
          ],
        ),
      ),
    );
  }
}

class _DuplicateCard extends ConsumerWidget {
  const _DuplicateCard({
    required this.link,
    required this.onSaveCopy,
    required this.onOpen,
  });

  final LinkItem link;
  final VoidCallback onSaveCopy;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final cols = ref.watch(collectionsProvider).value ?? const [];
    final name = _collectionName(cols, link.collectionId);
    final date = DateFormat('d MMM', Localizations.localeOf(context).toString())
        .format(link.createdAt.toLocal());
    final body = AppText.body(14, color: t.text);

    // "Saved on 12 Oct in **Design**".
    final line = name == null ? l.savedOn(date) : l.savedOnIn(date, name);
    final at = name == null ? -1 : line.lastIndexOf(name);
    final info = at < 0
        ? TextSpan(text: line, style: body)
        : TextSpan(style: body, children: [
            TextSpan(text: line.substring(0, at)),
            TextSpan(
                text: name,
                style: AppText.weight(body, FontWeight.w800)),
            TextSpan(text: line.substring(at + name!.length)),
          ]);

    return _OverlayCard(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Mascot(MascotMood.surprised, size: 70),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.duplicateTitle,
                        style: AppText.display(24,
                            height: 1.05, color: t.text)),
                    const SizedBox(height: 4),
                    Text.rich(info),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _MiniLinkRow(link: link),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 10,
                child: BoldButton(
                  label: l.saveCopy,
                  kind: BoldButtonKind.secondary,
                  size: BoldButtonSize.overlayLarge,
                  weight: FontWeight.w700,
                  expand: true,
                  onPressed: onSaveCopy,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 13,
                child: BoldButton(
                  label: l.openSaved,
                  size: BoldButtonSize.overlayLarge,
                  expand: true,
                  onPressed: onOpen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Colored row with a white thumb, title and domain (07).
class _MiniLinkRow extends StatelessWidget {
  const _MiniLinkRow({required this.link});

  final LinkItem link;

  @override
  Widget build(BuildContext context) {
    return BoldCard(
      fill: SceneColors.of(link.url).frame,
      radius: AppShape.rControl,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: boldBox(
              fill: AppColors.white,
              outline: AppColors.ink,
              radius: AppShape.rThumb,
            ),
            child: Center(
              child: AppIcon(
                link.kind == LinkKind.video ? AppIcons.play : AppIcons.lines,
                size: 20,
                color: AppColors.ink,
              ),
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
                        weight: FontWeight.w700, color: AppColors.ink)),
                const SizedBox(height: 2),
                Text(link.domain,
                    style: AppText.body(12,
                        weight: FontWeight.w600, color: AppColors.ink)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown when the shared text had no link.
class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    return _OverlayCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Mascot(MascotMood.confused, size: 70),
              const SizedBox(width: 14),
              Expanded(
                child: Text(l.noLinkShared,
                    style: AppText.body(15,
                        weight: FontWeight.w600, height: 1.4, color: t.text)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          BoldButton(
            label: l.done,
            size: BoldButtonSize.overlay,
            expand: true,
            onPressed: onDone,
          ),
        ],
      ),
    );
  }
}

/// Little outlined shapes above the "Saved!" card (22).
class _Confetti extends StatelessWidget {
  const _Confetti();

  @override
  Widget build(BuildContext context) {
    Widget piece(double w, double h, Color c, double r, double angle) =>
        Transform.rotate(
          angle: angle * 3.14159 / 180,
          child: Container(
            width: w,
            height: h,
            decoration: boldBox(fill: c, outline: AppColors.ink, radius: r),
          ),
        );
    return ExcludeSemantics(
      child: SizedBox(
        height: 110,
        child: Stack(
          children: [
            Positioned(left: 48, top: 30, child: piece(14, 24, AppColors.pink, 4, -30)),
            Positioned(left: 98, top: 0, child: piece(16, 16, AppColors.sky, 8, 0)),
            Positioned(right: 56, top: 10, child: piece(14, 24, AppColors.mint, 4, 24)),
            Positioned(right: 116, top: 50, child: piece(16, 16, AppColors.sun, 3, 45)),
            Positioned(left: 18, top: 80, child: piece(12, 12, AppColors.grape, 6, 0)),
          ],
        ),
      ),
    );
  }
}
