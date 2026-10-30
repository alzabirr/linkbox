import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkbox/app/app.dart';
import 'package:linkbox/core/providers.dart';
import 'package:linkbox/core/widgets/link_card.dart';
import 'package:linkbox/features/settings/theme_settings.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets('new user: intro → empty state → first link', (tester) async {
    tester.view.physicalSize = const Size(390, 844) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    // Fresh install: the intro has not been seen.
    final c = ProviderContainer(
        overrides: await testOverrides(onboardingDone: false));
    final prefs = c.read(sharedPrefsProvider);
    addTearDown(c.dispose);
    await tester.pumpWidget(
        UncontrolledProviderScope(container: c, child: const LinkboxApp()));
    await tester.pumpAndSettle();

    expect(find.text('Every link in one happy place'), findsOneWidget);
    await tester.tap(find.text('Let’s go'));
    await tester.pumpAndSettle();
    expect(find.text('Save from any app in one tap'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Your links stay on your phone'), findsOneWidget);
    await tester.tap(find.text('Start saving'));
    await tester.pumpAndSettle();

    expect(c.read(onboardingDoneProvider), isTrue);
    expect(prefs.getBool('onboarding_done'), isTrue);
    expect(find.text('Add first link'), findsOneWidget);

    await tester.tap(find.text('Add first link'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byType(TextField).last, 'https://example.com/first');
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 700)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save link'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pumpAndSettle();
    expect(find.byType(LinkCard), findsOneWidget);
  });

  test('settings are saved', () async {
    final c = ProviderContainer(overrides: await testOverrides());
    addTearDown(c.dispose);
    c.read(themeSettingsProvider.notifier)
      ..setMode(ThemeMode.dark)
      ..setAmoled(true)
      ..setAccent(const Color(0xFF5ED3C6));
    c.read(tapActionSettingProvider.notifier).set(TapAction.copy);
    final prefs = c.read(sharedPrefsProvider);
    expect(prefs.getString('theme_mode'), 'dark');
    expect(prefs.getBool('amoled'), isTrue);
    expect(prefs.getString('accent'), '#5ED3C6');
    expect(prefs.getString('tap_action'), 'copy');
    expect(parseHex('#ff8a3d'), const Color(0xFFFF8A3D));
    expect(parseHex('12345'), isNull);
  });
}
