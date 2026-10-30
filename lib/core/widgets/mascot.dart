import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/tokens.dart';

/// The bookmark mascot. Each mood has its own SVG in assets/mascot/.
enum MascotMood {
  happy(AppColors.sun),
  surprised(AppColors.sun),
  sad(AppColors.pink),
  confused(AppColors.grape),
  sleepy(AppColors.sun),
  cheer(AppColors.mint),

  /// Winking (24 About).
  wink(AppColors.sun),

  /// Big happy mascot with arms and legs (05, 16). 120 × 132.
  hero(AppColors.sun, 132 / 120),

  /// [hero] with closed eyes, for the blink.
  heroBlink(AppColors.sun, 132 / 120);

  const MascotMood(this.bodyColor, [this.aspect = 72 / 64]);

  /// Body fill used in the SVG file.
  final Color bodyColor;

  /// Height / width.
  final double aspect;

  String get asset => this == heroBlink
      ? 'assets/mascot/hero_blink.svg'
      : 'assets/mascot/$name.svg';
}

/// Decorative only: hidden from screen readers.
class Mascot extends StatelessWidget {
  const Mascot(this.mood, {super.key, this.size = 110, this.bodyColor});

  final MascotMood mood;

  /// Width in px; height keeps the 64 × 72 ratio.
  final double size;

  /// Optional body fill (e.g. white on the sun clipboard prompt).
  final Color? bodyColor;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SvgPicture.asset(
        mood.asset,
        width: size,
        height: size * mood.aspect,
        colorMapper: bodyColor == null
            ? null
            : _BodyColorMapper(mood.bodyColor, bodyColor!),
      ),
    );
  }
}

class _BodyColorMapper extends ColorMapper {
  const _BodyColorMapper(this.from, this.to);

  final Color from;
  final Color to;

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) => elementName == 'path' && attributeName == 'fill' && color == from
      ? to
      : color;

  @override
  bool operator ==(Object other) =>
      other is _BodyColorMapper && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(from, to);
}

/// The big mascot blinking every 4 s (120 ms), like the empty state in the
/// motion spec. Still when animations are turned off.
class BlinkingMascot extends StatefulWidget {
  const BlinkingMascot({super.key, required this.size, this.bodyColor});

  final double size;
  final Color? bodyColor;

  @override
  State<BlinkingMascot> createState() => _BlinkingMascotState();
}

class _BlinkingMascotState extends State<BlinkingMascot> {
  bool _closed = false;
  Timer? _every;
  Timer? _open;

  @override
  void initState() {
    super.initState();
    _every = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || AppMotion.reduce(context)) return;
      setState(() => _closed = true);
      _open = Timer(const Duration(milliseconds: 120), () {
        if (mounted) setState(() => _closed = false);
      });
    });
  }

  @override
  void dispose() {
    _every?.cancel();
    _open?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Mascot(
        _closed ? MascotMood.heroBlink : MascotMood.hero,
        size: widget.size,
        bodyColor: widget.bodyColor,
      );
}
