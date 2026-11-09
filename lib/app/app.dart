import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/links/links_providers.dart';
import '../features/settings/theme_settings.dart';
import '../l10n/app_localizations.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class LinkboxApp extends ConsumerWidget {
  const LinkboxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Finish previews left pending last time (e.g. saved offline).
    ref.watch(startupProvider);
    final theme = ref.watch(themeSettingsProvider);
    return DynamicColorBuilder(
      builder: (light, dark) {
        final accent = accentFor(theme, light?.primaryContainer);
        return MaterialApp.router(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(accent),
          darkTheme: AppTheme.dark(accent, amoled: theme.amoled),
          themeMode: theme.mode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          // Always English, even when the phone is set to Bangla.
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: appRouter,
          // Status bar icons: dark on light screens, light on dark ones.
          builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
            value: Theme.of(context).brightness == Brightness.dark
                ? SystemUiOverlayStyle.light.copyWith(
                    statusBarColor: Colors.transparent,
                  )
                : SystemUiOverlayStyle.dark.copyWith(
                    statusBarColor: Colors.transparent,
                  ),
            child: child!,
          ),
        );
      },
    );
  }
}

/// The accent to use: the wallpaper's soft primary with "Match my
/// wallpaper" on (Android 12+), else the picked accent. The container tone
/// keeps ink text readable on buttons.
Color accentFor(ThemeSettingsState theme, Color? wallpaper) =>
    theme.dynamicColor && wallpaper != null ? wallpaper : theme.accent;
