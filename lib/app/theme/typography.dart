import 'package:flutter/material.dart';

/// Font families and text-style builders.
///
/// Both main fonts are variable fonts, so every style sets the `wght` axis
/// (and `opsz` for Bricolage, like the browser does in the mockups) in
/// addition to [FontWeight].
class AppFonts {
  AppFonts._();

  static const display = 'BricolageGrotesque';
  static const body = 'Outfit';
  static const bangla = 'HindSiliguri';
  static const fallback = [bangla];
}

class AppText {
  AppText._();

  /// Bricolage Grotesque (headlines, card tags, numbers).
  static TextStyle display(
    double size, {
    FontWeight weight = FontWeight.w800,
    double? height,
    double? letterSpacing,
    Color? color,
  }) =>
      TextStyle(
        fontFamily: AppFonts.display,
        fontFamilyFallback: AppFonts.fallback,
        fontSize: size,
        fontWeight: weight,
        fontVariations: [
          FontVariation.weight(weight.value.toDouble()),
          FontVariation.opticalSize(size.clamp(12, 96).toDouble()),
        ],
        height: height,
        letterSpacing: letterSpacing,
        color: color,
      );

  /// Outfit (body, labels, buttons).
  static TextStyle body(
    double size, {
    FontWeight weight = FontWeight.w500,
    double? height,
    double? letterSpacing,
    Color? color,
  }) =>
      TextStyle(
        fontFamily: AppFonts.body,
        fontFamilyFallback: AppFonts.fallback,
        fontSize: size,
        fontWeight: weight,
        fontVariations: [FontVariation.weight(weight.value.toDouble())],
        height: height,
        letterSpacing: letterSpacing,
        color: color,
      );

  /// Re-weights any style and keeps the variable-font axis in sync.
  static TextStyle weight(TextStyle s, FontWeight w) => s.copyWith(
        fontWeight: w,
        fontVariations: [
          ...?s.fontVariations?.where((v) => v.axis != 'wght'),
          FontVariation.weight(w.value.toDouble()),
        ],
      );

  /// Material text theme (THEME.md section 2).
  static TextTheme textTheme(Color text) => TextTheme(
        displayLarge: display(40, height: 1.02, letterSpacing: -1),
        headlineLarge: display(32, height: 1.0, letterSpacing: -0.8),
        headlineMedium: display(28, letterSpacing: -0.5),
        headlineSmall: display(22),
        titleLarge: display(20),
        titleMedium: display(17),
        titleSmall: body(14, weight: FontWeight.w700, height: 1.3),
        labelLarge: body(17, weight: FontWeight.w800),
        labelMedium: body(14, weight: FontWeight.w700),
        labelSmall: body(12, weight: FontWeight.w600),
        bodyLarge: body(16, height: 1.5),
        bodyMedium: body(15, height: 1.5),
        bodySmall: body(13),
      ).apply(bodyColor: text, displayColor: text);

  /// "DESIGN", "NO.001" on cards.
  static TextStyle cardTag({Color? color}) =>
      display(12, letterSpacing: 0.4, color: color);
}

extension AppTextX on BuildContext {
  TextTheme get text => Theme.of(this).textTheme;
}
