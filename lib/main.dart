import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/providers.dart';

// Keeps the share overlay's entry point (ShareActivity.kt) in the build.
export 'share_main.dart' show shareMain;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(_fontLicenses);
  final prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
    child: const LinkboxApp(),
  ));
}

/// The bundled fonts' SIL Open Font License, for About › Licenses.
Stream<LicenseEntry> _fontLicenses() async* {
  for (final (name, file) in [
    ('Bricolage Grotesque', 'OFL-BricolageGrotesque.txt'),
    ('Outfit', 'OFL-Outfit.txt'),
    ('Hind Siliguri', 'OFL-HindSiliguri.txt'),
  ]) {
    yield LicenseEntryWithLineBreaks(
        [name], await rootBundle.loadString('assets/fonts/$file'));
  }
}
