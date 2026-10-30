import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkbox/core/models/link_item.dart';
import 'package:linkbox/core/models/link_sort.dart';
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

  test('sorts newest, oldest, A–Z, Z–A', () async {
    for (final p in ['b', 'c', 'a']) {
      await repo.add('https://example.com/$p');
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    await settle();
    Future<List<String?>> titles(LinkSort s) async =>
        (await repo.watchLinks(sort: s).first).map((l) => l.title).toList();
    expect(await titles(LinkSort.newest), ['Page /a', 'Page /c', 'Page /b']);
    expect(await titles(LinkSort.oldest), ['Page /b', 'Page /c', 'Page /a']);
    expect(await titles(LinkSort.az), ['Page /a', 'Page /b', 'Page /c']);
    expect(await titles(LinkSort.za), ['Page /c', 'Page /b', 'Page /a']);
  });

  test('search matches title or link, ignoring case', () async {
    await repo.add('https://example.com/flutter-tips');
    await repo.add('https://other.org/recipes');
    await settle();
    expect(await repo.watchLinks(query: 'FLUTTER').first, hasLength(1));
    expect(await repo.watchLinks(query: 'other.org').first, hasLength(1));
    expect(await repo.watchLinks(query: 'nothing').first, isEmpty);
    expect(await repo.watchLinks(query: '%').first, isEmpty);
  });

  test('soft delete hides, undo brings back, purge removes', () async {
    final id = await repo.add('https://example.com/a');
    await settle();
    await repo.softDelete([id]);
    expect(await repo.watchLinks().first, isEmpty);
    await repo.undoDelete([id]);
    expect(await repo.watchLinks().first, hasLength(1));
    await repo.softDelete([id]);
    await repo.purgeDeleted();
    await repo.undoDelete([id]);
    expect(await repo.watchLinks().first, isEmpty);
  });

  test('edit saves title, summary and own picture', () async {
    final id = await repo.add('https://example.com/a');
    await settle();
    await repo.updateDetails(id,
        title: '  My title ',
        description: '',
        imageUrl: null,
        customImagePath: '/tmp/x.jpg');
    final link = (await repo.findById(id))!;
    expect(link.title, 'My title');
    expect(link.description, isNull);
    expect(link.customImagePath, '/tmp/x.jpg');
  });
}
