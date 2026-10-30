import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkbox/app/app.dart';
import 'package:linkbox/core/widgets/link_card.dart';
import 'package:linkbox/core/widgets/link_tile.dart';
import 'package:linkbox/core/widgets/scene_art.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets('add a link by hand, see it as a card, switch to list',
      (tester) async {
    final overrides = await testOverrides();
    await tester.pumpWidget(
        ProviderScope(overrides: overrides, child: const LinkboxApp()));
    await tester.pumpAndSettle();

    // Empty state + 3 tabs.
    expect(find.text('Save it now. Find it later.'), findsOneWidget);
    expect(find.text('Collections'), findsOneWidget);

    await tester.tap(find.text('Add link'));
    await tester.pumpAndSettle();
    expect(find.text('Add a link'), findsOneWidget);

    // Not a link → error, Save disabled.
    await tester.enterText(find.byType(TextField).last, 'example.com');
    await tester.pump();
    expect(find.textContaining('doesn’t look like a link'), findsOneWidget);

    await tester.enterText(
        find.byType(TextField).last, 'https://example.com/hello');
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 700)));
    await tester.pumpAndSettle();
    expect(find.text('Found the title, summary and image'), findsOneWidget);

    await tester.tap(find.text('Save link'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pumpAndSettle();

    expect(find.byType(LinkCard), findsOneWidget);
    expect(find.text('Page /hello'), findsOneWidget);

    await tester.tap(find.byTooltip('Switch to list view'));
    await tester.pumpAndSettle();
    expect(find.byType(LinkTile), findsOneWidget);
  });

  test('scene colors are stable for the same link', () {
    final a = SceneColors.of('https://youtube.com/watch?v=1');
    final b = SceneColors.of('https://youtube.com/watch?v=1');
    expect(a.frame, b.frame);
    expect(a.sky, b.sky);
    expect(a.sky == a.ground, isFalse);
  });
}
