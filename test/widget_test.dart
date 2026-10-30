import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkbox/app/app.dart';
import 'package:linkbox/core/widgets/scene_art.dart';

void main() {
  testWidgets('app starts with the 3-tab bar and switches tabs',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: LinkboxApp()));
    await tester.pumpAndSettle();

    expect(find.text('Your links'), findsOneWidget);
    expect(find.text('Links'), findsOneWidget);
    expect(find.text('Collections'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Widget gallery'), findsOneWidget);

    await tester.tap(find.text('Widget gallery'));
    await tester.pumpAndSettle();
    expect(find.text('Buttons'), findsOneWidget);
  });

  test('scene colors are stable for the same link', () {
    final a = SceneColors.of('https://youtube.com/watch?v=1');
    final b = SceneColors.of('https://youtube.com/watch?v=1');
    expect(a.frame, b.frame);
    expect(a.sky, b.sky);
    expect(a.sky == a.ground, isFalse);
  });

}
