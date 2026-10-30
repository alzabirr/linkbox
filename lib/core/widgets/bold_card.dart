import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';

/// The base of almost every surface: flat fill, 2.5 px outline and an
/// optional hard offset shadow. When tappable it "pushes in" on press: the
/// shadow shrinks to 0 while the box moves by the same offset (90 ms).
class BoldCard extends StatefulWidget {
  const BoldCard({
    super.key,
    required this.child,
    this.fill,
    this.outline,
    this.radius = AppShape.rCard,
    this.stroke = AppShape.stroke,
    this.shadow = 0,
    this.padding,
    this.width,
    this.height,
    this.onTap,
    this.onLongPress,
    this.semanticLabel,
    this.selected,
    this.clip = false,
    this.dashed = false,
  });

  final Widget child;

  /// Defaults to the theme surface.
  final Color? fill;

  /// Defaults to the theme outline (ink, or white in dark mode).
  final Color? outline;
  final double radius;
  final double stroke;

  /// Shadow offset in px (use [AppShadows.offSm]… or 0 for none).
  final double shadow;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? semanticLabel;

  /// For toggle-like cards; announced to screen readers.
  final bool? selected;

  /// Clip children to the rounded shape (pictures).
  final bool clip;

  /// Dashed outline ("+ New", "Create a collection", failed preview).
  final bool dashed;

  @override
  State<BoldCard> createState() => _BoldCardState();
}

class _BoldCardState extends State<BoldCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press = AnimationController(
    vsync: this,
    duration: AppMotion.press,
  );

  bool get _interactive => widget.onTap != null || widget.onLongPress != null;

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  void _down(_) {
    if (AppMotion.reduce(context)) return;
    _press.forward();
  }

  void _up([_]) => _press.reverse();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final fill = widget.fill ?? t.surface;
    final outline = widget.outline ?? t.outline;
    final canShadow = t.hasShadow && widget.shadow > 0;

    Widget box(double p) {
      final offset = canShadow ? widget.shadow * p : 0.0;
      final shadowNow = canShadow ? widget.shadow - offset : 0.0;
      final radius = BorderRadius.circular(widget.radius);
      Widget inner = Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: widget.child,
      );
      if (widget.clip) {
        inner = ClipRRect(
          borderRadius: BorderRadius.circular(
            (widget.radius - widget.stroke).clamp(0, double.infinity),
          ),
          child: inner,
        );
      }
      final decorated = widget.dashed
          ? CustomPaint(
              foregroundPainter: DashedBorderPainter(
                color: outline,
                stroke: widget.stroke,
                radius: widget.radius,
              ),
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(color: fill, borderRadius: radius),
                padding: EdgeInsets.all(widget.stroke),
                child: inner,
              ),
            )
          : Container(
              width: widget.width,
              height: widget.height,
              decoration: boldBox(
                fill: fill,
                outline: outline,
                radius: widget.radius,
                stroke: widget.stroke,
                shadow: t.shadowOf(shadowNow),
              ),
              child: inner,
            );
      return Transform.translate(
        offset: Offset(offset, offset),
        child: decorated,
      );
    }

    if (!_interactive) return box(0);

    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _down,
        onTapUp: _up,
        onTapCancel: _up,
        onLongPressStart: widget.onLongPress == null ? null : (_) => _up(),
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: AnimatedBuilder(
          animation: _press,
          builder: (context, _) => box(Curves.easeOut.transform(_press.value)),
        ),
      ),
    );
  }
}

/// Dashed rounded-rect outline (CSS `border: 2.5px dashed`).
class DashedBorderPainter extends CustomPainter {
  DashedBorderPainter({
    required this.color,
    required this.stroke,
    required this.radius,
    this.dash = 7,
    this.gap = 5,
  });

  final Color color;
  final double stroke;
  final double radius;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(radius - stroke / 2)),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + dash), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(DashedBorderPainter old) =>
      old.color != color || old.stroke != stroke || old.radius != radius;
}
