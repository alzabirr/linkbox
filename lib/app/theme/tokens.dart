import 'package:flutter/material.dart';

/// Every color in the app. Widgets read the mode-dependent ones through
/// [AppTokens] (`context.tokens`) and only use these directly for fixed
/// palette fills (cards, chips, collection colors).
class AppColors {
  AppColors._();

  static const ink = Color(0xFF141414);
  static const paper = Color(0xFFFDF6EC);
  static const surface = Color(0xFFFFFFFF);
  static const sand = Color(0xFFF3EBDD);
  static const sandDeep = Color(0xFFEADFCB); // switch track off, loading bars
  static const sandLine = Color(0xFFD9CDB8);
  static const muted = Color(0xFF4A4A4A);
  static const primary = Color(0xFFFF8A3D);
  static const sun = Color(0xFFFFD23F);
  static const pink = Color(0xFFFF9FC4);
  static const sky = Color(0xFF7CC4FF);
  static const mint = Color(0xFF7DDBA3);
  static const grape = Color(0xFFB79CFF);
  static const peach = Color(0xFFFF9F6B);
  static const cream = Color(0xFFFFF1C7);
  static const blush = Color(0xFFFF8FB8); // mascot cheeks
  static const danger = Color(0xFFFF6B5E);
  static const dangerText = Color(0xFFB42318);
  static const dangerTextDark = Color(0xFFFF8A80);
  static const successText = Color(0xFF14532D);

  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const darkSurface = Color(0xFF141414);
  static const darkRaised = Color(0xFF1E1E1E);
  static const darkMuted = Color(0xFFC8C8C8);
  static const inkTrack = Color(0xFF3A3A3A); // undo bar progress track

  /// Card frame / collection fills, picked by hash.
  static const cardFills = [pink, sky, sun, peach, mint, grape];

  /// Collection colors (screen 20): the 6 from the mockup, then 6 more
  /// from the accent palette. Ink text passes 4.5:1 on all of them.
  static const collectionColors = [
    pink, sky, sun, mint, grape, peach,
    Color(0xFFFF8A3D), // orange
    Color(0xFFC6EB5B), // lime
    Color(0xFF5ED3C6), // teal
    danger, // coral
    Color(0xFFD7B8FF), // lilac
    Color(0xFFE8C9A0), // sand
  ];

  /// Accent choices (screen 25). Name keys live in the .arb files.
  static const accents = <Color>[
    Color(0xFFFF8A3D), // Orange (default)
    Color(0xFFFFD23F), // Sun
    Color(0xFF7DDBA3), // Mint
    Color(0xFF7CC4FF), // Sky
    Color(0xFFB79CFF), // Grape
    Color(0xFFFF9FC4), // Pink
    Color(0xFFFF9F6B), // Peach
    Color(0xFFC6EB5B), // Lime
    Color(0xFF5ED3C6), // Teal
    Color(0xFFFF6B5E), // Coral
    Color(0xFFD7B8FF), // Lilac
    Color(0xFFE8C9A0), // Sand
  ];
}

class AppShape {
  AppShape._();

  static const stroke = 2.5;
  static const strokeHeavy = 3.5;
  static const strokeThin = 2.0;

  static const rBadge = 8.0;
  static const rChip = 19.0;
  static const rTiny = 12.0;
  static const rThumb = 13.0;
  static const rSmall = 14.0;
  static const rControlSm = 16.0;
  static const rControl = 18.0;
  static const rCard = 20.0;
  static const rSection = 22.0;
  static const rSheet = 28.0;
  static const rPanel = 32.0;
}

class AppSizes {
  AppSizes._();

  static const iconBox = 46.0;
  static const searchHeight = 52.0;
  static const chipHeight = 38.0;
  static const buttonHeight = 56.0;
  static const buttonHeightLg = 60.0;
  static const fabHeight = 58.0;
  static const listThumb = 52.0;
  static const cardPicture = 92.0;
  static const navHeight = 84.0;
  static const navPillW = 60.0;
  static const navPillH = 32.0;
  static const grabberW = 44.0;
  static const grabberH = 5.0;
  static const switchW = 58.0;
  static const switchH = 34.0;
  static const switchThumb = 23.0;
  static const minTouch = 44.0;

  static const gridGap = 14.0;
  static const listGap = 10.0;
}

class AppShadows {
  AppShadows._();

  static const offSm = 3.0;
  static const offMd = 4.0;
  static const offLg = 5.0;
  static const offXl = 6.0;

  static List<BoxShadow> hard(double o, Color color) => [
    BoxShadow(color: color, offset: Offset(o, o), blurRadius: 0),
  ];
}

class AppMotion {
  AppMotion._();

  static const press = Duration(milliseconds: 90);
  static const sheet = Duration(milliseconds: 280);
  static const pop = Duration(milliseconds: 320);
  static const select = Duration(milliseconds: 160);
  static const swap = Duration(milliseconds: 200);
  static const delete = Duration(milliseconds: 220);
  static const reduced = Duration(milliseconds: 120);

  /// Material 3 "emphasized" curve.
  static const emphasized = Cubic(0.2, 0.0, 0, 1.0);

  static bool reduce(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;
}

/// Colors that change between light, dark and AMOLED.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.isDark,
    required this.background,
    required this.surface,
    required this.raised,
    required this.outline,
    required this.text,
    required this.muted,
    required this.shadow,
    required this.sand,
    required this.sandDeep,
    required this.sandLine,
    required this.accent,
    required this.selectedFill,
    required this.onSelectedFill,
    required this.dangerText,
  });

  final bool isDark;

  /// Page background.
  final Color background;

  /// Cards, inputs, nav bar, sheets.
  final Color surface;

  /// Small boxes inside a surface (dark mode only differs).
  final Color raised;

  /// 2.5 px outline on every surface.
  final Color outline;
  final Color text;
  final Color muted;

  /// Hard offset shadow. Transparent in dark mode (mockups 15 and 30).
  final Color shadow;
  final Color sand;
  final Color sandDeep;
  final Color sandLine;

  /// User-picked accent (Add link, Save, FAB…).
  final Color accent;

  /// Selected chip, "All" chip, dark buttons.
  final Color selectedFill;
  final Color onSelectedFill;
  final Color dangerText;

  bool get hasShadow => shadow.a > 0;

  List<BoxShadow>? shadowOf(double offset) =>
      hasShadow && offset > 0 ? AppShadows.hard(offset, shadow) : null;

  static AppTokens light(Color accent) => AppTokens(
    isDark: false,
    background: AppColors.paper,
    surface: AppColors.surface,
    raised: AppColors.surface,
    outline: AppColors.ink,
    text: AppColors.ink,
    muted: AppColors.muted,
    shadow: AppColors.ink,
    sand: AppColors.sand,
    sandDeep: AppColors.sandDeep,
    sandLine: AppColors.sandLine,
    accent: accent,
    selectedFill: AppColors.ink,
    onSelectedFill: AppColors.white,
    dangerText: AppColors.dangerText,
  );

  static AppTokens dark(Color accent, {required bool amoled}) => AppTokens(
    isDark: true,
    background: amoled ? AppColors.black : AppColors.darkSurface,
    surface: amoled ? AppColors.darkSurface : AppColors.darkRaised,
    raised: AppColors.darkRaised,
    outline: AppColors.white,
    text: AppColors.white,
    muted: AppColors.darkMuted,
    shadow: const Color(0x00000000),
    sand: AppColors.darkRaised,
    sandDeep: const Color(0xFF3A3A3A),
    sandLine: const Color(0xFF3A3A3A),
    accent: accent,
    selectedFill: AppColors.white,
    onSelectedFill: AppColors.black,
    dangerText: AppColors.dangerTextDark,
  );

  @override
  AppTokens copyWith({Color? accent}) => AppTokens(
    isDark: isDark,
    background: background,
    surface: surface,
    raised: raised,
    outline: outline,
    text: text,
    muted: muted,
    shadow: shadow,
    sand: sand,
    sandDeep: sandDeep,
    sandLine: sandLine,
    accent: accent ?? this.accent,
    selectedFill: selectedFill,
    onSelectedFill: onSelectedFill,
    dangerText: dangerText,
  );

  @override
  AppTokens lerp(AppTokens? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppTokens(
      isDark: t < 0.5 ? isDark : other.isDark,
      background: l(background, other.background),
      surface: l(surface, other.surface),
      raised: l(raised, other.raised),
      outline: l(outline, other.outline),
      text: l(text, other.text),
      muted: l(muted, other.muted),
      shadow: l(shadow, other.shadow),
      sand: l(sand, other.sand),
      sandDeep: l(sandDeep, other.sandDeep),
      sandLine: l(sandLine, other.sandLine),
      accent: l(accent, other.accent),
      selectedFill: l(selectedFill, other.selectedFill),
      onSelectedFill: l(onSelectedFill, other.onSelectedFill),
      dangerText: l(dangerText, other.dangerText),
    );
  }
}

extension AppTokensX on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;
}

/// The one decoration almost every surface uses.
BoxDecoration boldBox({
  required Color fill,
  required Color outline,
  double radius = AppShape.rCard,
  double stroke = AppShape.stroke,
  List<BoxShadow>? shadow,
}) => BoxDecoration(
  color: fill,
  borderRadius: BorderRadius.circular(radius),
  border: Border.all(color: outline, width: stroke),
  boxShadow: shadow,
);
