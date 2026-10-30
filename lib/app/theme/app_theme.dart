import 'package:flutter/material.dart';

import 'tokens.dart';
import 'typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light(Color accent) => _build(AppTokens.light(accent));

  static ThemeData dark(Color accent, {bool amoled = false}) =>
      _build(AppTokens.dark(accent, amoled: amoled));

  static ThemeData _build(AppTokens t) {
    final brightness = t.isDark ? Brightness.dark : Brightness.light;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: t.accent,
      onPrimary: AppColors.ink,
      secondary: AppColors.sun,
      onSecondary: AppColors.ink,
      error: AppColors.danger,
      onError: AppColors.ink,
      surface: t.surface,
      onSurface: t.text,
      onSurfaceVariant: t.muted,
      outline: t.outline,
      shadow: t.shadow,
    );
    final text = AppText.textTheme(t.text);
    final outline = BorderSide(color: t.outline, width: AppShape.stroke);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: t.background,
      canvasColor: t.background,
      fontFamily: AppFonts.body,
      fontFamilyFallback: AppFonts.fallback,
      textTheme: text,
      extensions: [t],
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: t.text,
        selectionColor: AppColors.sun.withValues(alpha: 0.6),
        selectionHandleColor: t.text,
      ),
      iconTheme: IconThemeData(color: t.text, size: 22),
      dividerTheme: DividerThemeData(color: t.sandLine, thickness: 2),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: t.background,
        modalBackgroundColor: t.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        showDragHandle: false,
        modalBarrierColor: AppColors.ink.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(AppShape.rSheet)),
          side: outline,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: t.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        barrierColor: AppColors.ink.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppShape.rSheet),
          side: outline,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: AppText.body(15,
            weight: FontWeight.w700, color: AppColors.white),
        elevation: 0,
        behavior: SnackBarBehavior.floating,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: t.text),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(AppShape.rTiny),
        ),
        textStyle: AppText.body(13,
            weight: FontWeight.w600, color: AppColors.white),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
      }),
    );
  }
}
