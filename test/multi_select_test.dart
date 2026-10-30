import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkbox/app/app.dart';
import 'package:linkbox/core/providers.dart';
import 'package:linkbox/core/widgets/link_card.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets('long-press, select 3, delete, undo', (tester) async {
    tester.view.physicalSize = const Size(390, 1600) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final c = ProviderContainer(overrides: await testOverrides());
    addTearDown(c.dispose);
    await tester.runAsync(() async {
      for (var i = 0; i < 4; i++) {
        await c.read(linkRepositoryProvider).add('https://example.com/$i');
      }
      await Future<void>.delayed(const Duration(milliseconds: 150));
    });
    await tester.pumpWidget(
        UncontrolledProviderScope(container: c, child: const LinkboxApp()));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pumpAndSettle();

    final cards = find.byType(LinkCard);
    expect(cards, findsNWidgets(4));
    await tester.longPress(cards.at(0));
    await tester.pumpAndSettle();
    expect(find.text('1 selected'), findsOneWidget);
    await tester.tap(cards.at(1));
    await tester.tap(cards.at(2));
    await tester.pumpAndSettle();
    expect(find.text('3 selected'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete 3 links'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Deleted 3 links'), findsOneWidget);
    expect(find.byType(LinkCard), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pumpAndSettle();
    expect(find.byType(LinkCard), findsNWidgets(4));
  });
}
