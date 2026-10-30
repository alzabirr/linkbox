import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkbox/core/providers.dart';
import 'package:linkbox/core/repositories/collection_repository.dart';

import 'helpers/test_app.dart';

void main() {
  late ProviderContainer c;
  late CollectionRepository cols;

  setUp(() async {
    c = ProviderContainer(overrides: await testOverrides());
    cols = c.read(collectionRepositoryProvider);
  });
  tearDown(() => c.dispose());

  test('names are unique, ignoring case', () async {
    await cols.create('Design', colorHex: '#FF9FC4');
    expect(() => cols.create('  design ', colorHex: '#7CC4FF'),
        throwsA(isA<DuplicateCollectionException>()));
    final dev = await cols.create('Dev', colorHex: '#7CC4FF');
    expect(() => cols.update(dev, name: 'DESIGN', colorHex: '#7CC4FF', icon: 'code'),
        throwsA(isA<DuplicateCollectionException>()));
    // Renaming to its own name in another case is fine.
    await cols.update(dev, name: 'DEV', colorHex: '#7CC4FF', icon: 'code');
    final all = await cols.watchAll().first;
    expect(all.map((e) => e.name), ['Design', 'DEV']);
  });

  test('pinned collections come first', () async {
    await cols.create('A', colorHex: '#FF9FC4');
    final b = await cols.create('B', colorHex: '#FF9FC4');
    await cols.setPinned(b, true);
    expect((await cols.watchAll().first).first.name, 'B');
  });

  test('deleting a collection keeps its links', () async {
    final links = c.read(linkRepositoryProvider);
    final design = await cols.create('Design', colorHex: '#FF9FC4');
    final id = await links.add('https://example.com/a', collectionId: design);
    await links.add('https://example.com/b', collectionId: design);
    expect((await cols.watchStats().first)[design]!.count, 2);

    await cols.delete(design);
    expect(await cols.watchAll().first, isEmpty);
    final link = await links.findById(id);
    expect(link, isNotNull);
    expect(link!.collectionId, isNull);
  });

  test('sort 30 links into 4 collections', () async {
    final links = c.read(linkRepositoryProvider);
    final ids = [
      for (var i = 0; i < 30; i++) await links.add('https://example.com/$i'),
    ];
    final colIds = [
      for (final n in ['Design', 'Dev', 'Recipes', 'Read later'])
        await cols.create(n, colorHex: '#FF9FC4'),
    ];
    for (var i = 0; i < 4; i++) {
      await links.moveLinks(ids.where((id) => id % 4 == i).toList(), colIds[i]);
    }
    final stats = await cols.watchStats().first;
    expect(stats.values.fold<int>(0, (a, s) => a + s.count), 30);
  });
}
