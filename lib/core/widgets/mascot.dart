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
  cheer(AppColors.mint);

  const MascotMood(this.bodyColor);

  /// Body fill used in the SVG file.
  final Color bodyColor;

  String get asset => 'assets/mascot/$name.svg';
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
        height: size * 72 / 64,
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
  ) =>
      elementName == 'path' && attributeName == 'fill' && color == from
          ? to
          : color;

  @override
  bool operator ==(Object other) =>
      other is _BodyColorMapper && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(from, to);
}
