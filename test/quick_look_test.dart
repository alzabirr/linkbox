import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkbox/app/app.dart';
import 'package:linkbox/core/providers.dart';
import 'package:linkbox/core/widgets/link_card.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets('tap a card → Quick look → Delete → Undo', (tester) async {
    final c = ProviderContainer(overrides: await testOverrides());
    addTearDown(c.dispose);
    await tester.runAsync(() async {
      await c.read(linkRepositoryProvider).add('https://example.com/hello');
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pumpWidget(
        UncontrolledProviderScope(container: c, child: const LinkboxApp()));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(LinkCard));
    await tester.pumpAndSettle();
    expect(find.text('Open'), findsOneWidget);
    expect(find.text('example.com · Saved today'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Delete this link?'), findsOneWidget);
    await tester.tap(find.text('Delete 1 link'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Deleted 1 link'), findsOneWidget);
    expect(find.byType(LinkCard), findsNothing);

    await tester.pump(const Duration(milliseconds: 400)); // bar slides in
    await tester.tap(find.text('Undo'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pumpAndSettle();
    expect(find.byType(LinkCard), findsOneWidget);
  });
}
