import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/theme/app_theme.dart';
import 'core/providers.dart';
import 'features/settings/theme_settings.dart';
import 'features/share/share_overlay_page.dart';
import 'l10n/app_localizations.dart';

/// Entry point for the share overlay (android ShareActivity.kt).
@pragma('vm:entry-point')
Future<void> shareMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
      child: const ShareApp(),
    ),
  );
}

class ShareApp extends ConsumerWidget {
  const ShareApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeSettingsProvider);
    return DynamicColorBuilder(
      builder: (light, _) {
        final accent = accentFor(theme, light?.primaryContainer);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          theme: AppTheme.light(accent),
          darkTheme: AppTheme.dark(accent, amoled: theme.amoled),
          themeMode: theme.mode,
          color: Colors.transparent,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ShareOverlayPage(),
        );
      },
    );
  }
}
