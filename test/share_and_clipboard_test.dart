import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:linkbox/core/providers.dart';
import 'package:linkbox/features/links/clipboard_prompt_controller.dart';
import 'package:linkbox/features/share/share_controller.dart';

import 'helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  const share = MethodChannel('linkbox/share');

  void shareText(String? text, {String? subject}) {
    messenger.setMockMethodCallHandler(share, (call) async {
      if (call.method == 'getShared') {
        return {'text': text, 'subject': subject};
      }
      return null;
    });
  }

  Future<ShareState> runShare(ProviderContainer c) async {
    c.read(shareControllerProvider);
    for (var i = 0; i < 50; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      if (c.read(shareControllerProvider) is! ShareLoading) break;
    }
    return c.read(shareControllerProvider);
  }

  group('share sheet', () {
    late ProviderContainer c;
    late List<Override> overrides;
    setUp(() async => overrides = await testOverrides());
    tearDown(() => c.dispose());

    test('saves the first link found in the shared text', () async {
      shareText('Look at this https://example.com/a?utm_source=x !',
          subject: 'A nice page');
      c = ProviderContainer(overrides: overrides);
      final s = await runShare(c);
      expect(s, isA<ShareSaved>());
      expect((s as ShareSaved).link.url, 'https://example.com/a?utm_source=x');
    });

    test('second share of the same page shows the duplicate card', () async {
      c = ProviderContainer(overrides: overrides);
      await c.read(linkRepositoryProvider).add('https://example.com/a');
      shareText('https://www.example.com/a/');
      final s = await runShare(c);
      expect(s, isA<ShareDuplicate>());

      await c.read(shareControllerProvider.notifier).saveCopy();
      expect(c.read(shareControllerProvider), isA<ShareSaved>());
      final all = await c.read(linkRepositoryProvider).watchLinks().first;
      expect(all, hasLength(2));
    });

    test('text without a link', () async {
      shareText('just words');
      c = ProviderContainer(overrides: overrides);
      expect(await runShare(c), isA<ShareNoLink>());
    });
  });

  group('clipboard prompt', () {
    String? clip;
    setUp(() {
      messenger.setMockMethodCallHandler(SystemChannels.platform,
          (call) async {
        switch (call.method) {
          case 'Clipboard.hasStrings':
            return {'value': clip != null};
          case 'Clipboard.getData':
            return clip == null ? null : {'text': clip};
        }
        return null;
      });
    });

    test('offers a copied link once, never a saved one', () async {
      final c = ProviderContainer(overrides: await testOverrides());
      addTearDown(c.dispose);
      final prompt = c.read(clipboardPromptProvider.notifier);

      clip = 'https://example.com/copied';
      await prompt.check();
      expect(c.read(clipboardPromptProvider), clip);

      prompt.dismiss(); // Not now
      await prompt.check();
      expect(c.read(clipboardPromptProvider), isNull);

      clip = 'https://example.com/other';
      await prompt.check();
      await prompt.save();
      expect(await c.read(linkRepositoryProvider).findByUrl(clip!), isNotNull);

      clip = 'not a link';
      await prompt.check();
      expect(c.read(clipboardPromptProvider), isNull);
    });
  });
}
