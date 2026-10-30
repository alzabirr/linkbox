import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import 'app_icon.dart';

/// What kind of page a link points to (drives the badge glyph).
enum LinkKind { video, article, post, other }

/// Colors for a link card, picked from the palette by a stable hash of the
/// URL, so the same link always looks the same.
@immutable
class SceneColors {
  const SceneColors({
    required this.frame,
    required this.sky,
    required this.sun,
    required this.ground,
  });

  final Color frame;
  final Color sky;
  final Color sun;
  final Color ground;

  static const _skies = [
    AppColors.sky,
    AppColors.cream,
    AppColors.grape,
    AppColors.mint,
  ];
  static const _suns = [AppColors.sun, AppColors.primary, AppColors.white];
  static const _grounds = [
    AppColors.mint,
    AppColors.grape,
    AppColors.peach,
    AppColors.pink,
    AppColors.sky,
    AppColors.sun,
  ];

  factory SceneColors.of(String seed) {
    final h = stableHash(seed);
    final frame = AppColors.cardFills[h % AppColors.cardFills.length];
    var sky = _skies[(h >> 4) % _skies.length];
    if (sky == frame) sky = AppColors.cream;
    var sun = _suns[(h >> 8) % _suns.length];
    if (sun == sky) sun = AppColors.white;
    var ground = _grounds[(h >> 12) % _grounds.length];
    if (ground == sky || ground == sun) {
      ground = _grounds[((h >> 12) + 1) % _grounds.length];
    }
    return SceneColors(frame: frame, sky: sky, sun: sun, ground: ground);
  }

  /// FNV-1a; unlike String.hashCode it is the same on every run.
  static int stableHash(String s) {
    var h = 0x811c9dc5;
    for (final c in s.codeUnits) {
      h ^= c;
      h = (h * 0x01000193) & 0x7fffffff;
    }
    return h;
  }
}

/// The flat "scene" drawn for links without a picture: sky, sun circle,
/// wavy hill and a white badge with a play triangle or three lines.
class SceneArt extends StatelessWidget {
  const SceneArt({
    super.key,
    required this.seed,
    this.kind = LinkKind.article,
    this.showBadge = true,
    this.badgeSize = 40,
  });

  final String seed;
  final LinkKind kind;
  final bool showBadge;
  final double badgeSize;

  @override
  Widget build(BuildContext context) {
    final c = SceneColors.of(seed);
    return ExcludeSemantics(
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _ScenePainter(c)),
          if (showBadge)
            Positioned(
              left: 14,
              top: 18,
              child: Container(
                width: badgeSize,
                height: badgeSize,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: AppColors.ink, width: AppShape.stroke),
                ),
                child: Center(
                  child: AppIcon(
                    kind == LinkKind.video ? AppIcons.play : AppIcons.lines,
                    size: 18,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScenePainter extends CustomPainter {
  _ScenePainter(this.c);

  final SceneColors c;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = c.sky);

    // Wide pictures use the card scene (viewBox 160 × 92), square thumbs
    // the Add link preview scene (92 × 92); both "xMidYMid slice".
    final square = size.width / size.height < 1.3;
    final vw = square ? 92.0 : 160.0;
    const vh = 92.0;
    final scale = (size.width / vw) > (size.height / vh)
        ? size.width / vw
        : size.height / vh;
    canvas.save();
    canvas.translate(
        (size.width - vw * scale) / 2, (size.height - vh * scale) / 2);
    canvas.scale(scale);

    final stroke = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppShape.stroke
      ..strokeJoin = StrokeJoin.round;

    final sun = square ? const Offset(68, 22) : const Offset(130, 24);
    final r = square ? 9.0 : 11.0;
    canvas.drawCircle(sun, r, Paint()..color = c.sun);
    canvas.drawCircle(sun, r, stroke);

    // Card:  M-4 70 Q36 52 80 66 T164 60 V96 H-4Z
    // Thumb: M-4 66 Q22 52 46 62 T96 58 V96 H-4Z
    final hill = square
        ? (Path()
          ..moveTo(-4, 66)
          ..quadraticBezierTo(22, 52, 46, 62)
          ..quadraticBezierTo(70, 72, 96, 58)
          ..lineTo(96, 96))
        : (Path()
          ..moveTo(-4, 70)
          ..quadraticBezierTo(36, 52, 80, 66)
          ..quadraticBezierTo(124, 80, 164, 60)
          ..lineTo(164, 96));
    hill
      ..lineTo(-4, 96)
      ..close();
    canvas.drawPath(hill, Paint()..color = c.ground);
    canvas.drawPath(hill, stroke);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ScenePainter old) =>
      old.c.sky != c.sky || old.c.sun != c.sun || old.c.ground != c.ground;
}
