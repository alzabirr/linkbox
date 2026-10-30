import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkbox/core/models/link_item.dart';
import 'package:linkbox/core/providers.dart';
import 'package:linkbox/core/repositories/link_repository.dart';

import 'helpers/test_app.dart';

void main() {
  late ProviderContainer c;
  late LinkRepository repo;

  setUp(() async {
    c = ProviderContainer(overrides: await testOverrides());
    repo = c.read(linkRepositoryProvider);
  });
  tearDown(() => c.dispose());

  Future<List<LinkItem>> settle() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return repo.watchLinks().first;
  }

  test('saves at once, then fills in the preview', () async {
    await repo.add('https://example.com/a');
    final links = await settle();
    expect(links, hasLength(1));
    expect(links.single.fetchStatus, FetchStatus.ok);
    expect(links.single.title, 'Page /a');
    expect(links.single.domain, 'example.com');
  });

  test('refuses the same link twice, even with tracking params', () async {
    await repo.add('https://www.example.com/a/');
    expect(() => repo.add('https://example.com/a?utm_source=x'),
        throwsA(isA<DuplicateLinkException>()));
  });

  test('marks broken pages as failed, and Try again re-fetches', () async {
    final id = await repo.add('https://example.com/broken');
    expect((await settle()).single.fetchStatus, FetchStatus.failed);
    await repo.retry(id);
    expect((await settle()).single.fetchStatus, FetchStatus.failed);
  });

  test('newest first and keeps all 10 links', () async {
    for (var i = 0; i < 10; i++) {
      await repo.add('https://example.com/$i');
    }
    final links = await settle();
    expect(links, hasLength(10));
    expect(links.first.url, 'https://example.com/9');
  });
}
