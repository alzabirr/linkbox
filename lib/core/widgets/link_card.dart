import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import 'app_icon.dart';
import 'bold_button.dart';
import 'bold_card.dart';
import 'scene_art.dart';

enum LinkCardState { normal, loading, failed }

/// Grid card: tag row, framed picture (or scene), 2-line title, domain and
/// number. Also draws the loading / preview-failed states (23) and the
/// multi-select look (10).
class LinkCard extends StatelessWidget {
  const LinkCard({
    super.key,
    required this.seed,
    required this.title,
    required this.domain,
    required this.number,
    this.collectionTag,
    this.kindLabel,
    this.kind = LinkKind.article,
    this.imageUrl,
    this.state = LinkCardState.normal,
    this.selecting = false,
    this.selected = false,
    this.onTap,
    this.onLongPress,
    this.onRetry,
    this.noPreviewLabel = '',
    this.retryLabel = '',
    this.loadingLabel = '',
  });

  /// Usually the URL; picks the card colors.
  final String seed;
  final String title;
  final String domain;

  /// "NO.001".
  final String number;

  /// Collection name (shown uppercase), or null for none.
  final String? collectionTag;

  /// "Video" / "Article" / "Post".
  final String? kindLabel;
  final LinkKind kind;
  final String? imageUrl;
  final LinkCardState state;

  /// Multi-select mode is on.
  final bool selecting;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onRetry;
  final String noPreviewLabel;
  final String retryLabel;
  final String loadingLabel;

  static const _pictureHeight = AppSizes.cardPicture;
  static const _statePictureHeight = 84.0;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final colors = SceneColors.of(seed);
    final plain = state != LinkCardState.normal;
    final fill = plain ? t.surface : colors.frame;
    final ink = plain ? t.text : AppColors.ink;
    final duration =
        AppMotion.reduce(context) ? AppMotion.reduced : AppMotion.select;

    final card = BoldCard(
      fill: fill,
      radius: AppShape.rCard,
      stroke: selected ? AppShape.strokeHeavy : AppShape.stroke,
      shadow: selecting
          ? (selected ? AppShadows.offLg : 0)
          : (plain ? 0 : AppShadows.offMd),
      padding: const EdgeInsets.all(8),
      onTap: onTap,
      onLongPress: onLongPress,
      selected: selecting ? selected : null,
      semanticLabel: '$title, $domain',
      child: DefaultTextStyle.merge(
        style: TextStyle(color: ink),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _TagRow(tag: collectionTag, kindLabel: kindLabel, color: ink),
            const SizedBox(height: 7),
            switch (state) {
              LinkCardState.normal => _Picture(
                  height: _pictureHeight,
                  seed: seed,
                  kind: kind,
                  imageUrl: imageUrl),
              LinkCardState.failed => _NoPreview(label: noPreviewLabel),
              LinkCardState.loading => const _Striped(),
            },
            const SizedBox(height: 7),
            ..._body(context, ink),
          ],
        ),
      ),
    );

    if (!selecting) return card;
    return AnimatedOpacity(
      duration: duration,
      opacity: selected ? 1 : 0.7,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          card,
          Positioned(
            right: -6,
            top: -6,
            child: _CheckBadge(on: selected, duration: duration),
          ),
        ],
      ),
    );
  }

  List<Widget> _body(BuildContext context, Color ink) {
    final t = context.tokens;
    switch (state) {
      case LinkCardState.normal:
        return [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 36),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.body(14,
                    weight: FontWeight.w700, height: 1.3, color: ink),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 2, 2),
            child: Row(
              children: [
                Expanded(
                  child: Text(domain,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body(11,
                          weight: FontWeight.w600, color: ink)),
                ),
                Text(number, style: AppText.cardTag(color: ink)),
              ],
            ),
          ),
        ];
      case LinkCardState.failed:
        return [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.body(13,
                  weight: FontWeight.w700, height: 1.3, color: ink),
            ),
          ),
          const SizedBox(height: 7),
          BoldButton(
            label: retryLabel,
            icon: AppIcons.retry,
            kind: BoldButtonKind.sun,
            size: BoldButtonSize.small,
            expand: true,
            shadow: false,
            onPressed: onRetry,
          ),
        ];
      case LinkCardState.loading:
        Widget bar(double f) => FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: f,
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: t.sandDeep,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            );
        return [
          bar(0.9),
          const SizedBox(height: 7),
          bar(0.6),
          const SizedBox(height: 7),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(loadingLabel,
                style: AppText.body(12,
                    weight: FontWeight.w600, color: t.muted)),
          ),
        ];
    }
  }
}

class _TagRow extends StatelessWidget {
  const _TagRow({this.tag, this.kindLabel, required this.color});

  final String? tag;
  final String? kindLabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              (tag ?? '').toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.cardTag(color: color),
            ),
          ),
          if (kindLabel != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              decoration: boldBox(
                fill: AppColors.white,
                outline: AppColors.ink,
                stroke: AppShape.strokeThin,
                radius: AppShape.rBadge,
              ),
              child: Text(kindLabel!,
                  style: AppText.body(11,
                      weight: FontWeight.w700, color: AppColors.ink)),
            ),
        ],
      ),
    );
  }
}

/// Framed picture area: the link's image, or the scene when there is none.
class _Picture extends StatelessWidget {
  const _Picture({
    required this.height,
    required this.seed,
    required this.kind,
    this.imageUrl,
  });

  final double height;
  final String seed;
  final LinkKind kind;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final scene = SceneArt(seed: seed, kind: kind);
    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: boldBox(
        fill: AppColors.white,
        outline: AppColors.ink,
        radius: AppShape.rSmall,
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(AppShape.rSmall - AppShape.stroke),
        child: imageUrl == null
            ? scene
            : CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, _) => scene,
                errorWidget: (_, _, _) => scene,
              ),
      ),
    );
  }
}

class _NoPreview extends StatelessWidget {
  const _NoPreview({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return BoldCard(
      height: LinkCard._statePictureHeight,
      fill: t.sand,
      radius: AppShape.rSmall,
      dashed: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcon(AppIcons.linkOff, size: 18, color: t.text),
          const SizedBox(width: 6),
          Text(label,
              style:
                  AppText.body(12, weight: FontWeight.w700, color: t.text)),
        ],
      ),
    );
  }
}

class _Striped extends StatelessWidget {
  const _Striped();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      height: LinkCard._statePictureHeight,
      clipBehavior: Clip.antiAlias,
      decoration: boldBox(
        fill: t.surface,
        outline: t.outline,
        radius: AppShape.rSmall,
      ),
      child: CustomPaint(painter: _StripePainter(t.sand, t.surface)),
    );
  }
}

/// repeating-linear-gradient(-45deg, sand 0 10px, white 10px 20px)
class _StripePainter extends CustomPainter {
  _StripePainter(this.a, this.b);

  final Color a;
  final Color b;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = b);
    final paint = Paint()
      ..color = a
      ..strokeWidth = 10 * 1.4142;
    // Stripes run bottom-left → top-right, 20 px period across them.
    const period = 20 * 1.4142;
    for (var x = -size.height; x < size.width + size.height; x += period) {
      canvas.drawLine(Offset(x, size.height + 10),
          Offset(x + size.height + 20, -10), paint);
    }
  }

  @override
  bool shouldRepaint(_StripePainter old) => old.a != a || old.b != b;
}

class _CheckBadge extends StatelessWidget {
  const _CheckBadge({required this.on, required this.duration});

  final bool on;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: on ? AppColors.ink : AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.ink, width: AppShape.stroke),
      ),
      child: AnimatedOpacity(
        duration: duration,
        opacity: on ? 1 : 0,
        child: AnimatedScale(
          duration: duration,
          scale: on ? 1 : 0.6,
          curve: Curves.easeOutBack,
          child: const Center(
            child: AppIcon(AppIcons.check,
                size: 15, color: AppColors.white, strokeWidth: 3.6),
          ),
        ),
      ),
    );
  }
}
