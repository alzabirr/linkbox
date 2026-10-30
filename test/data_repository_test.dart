import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkbox/core/providers.dart';
import 'package:linkbox/core/services/backup_format.dart';

import 'helpers/test_app.dart';

void main() {
  Future<ProviderContainer> app() async =>
      ProviderContainer(overrides: await testOverrides());

  test('backup → fresh install → restore brings everything back', () async {
    final a = await app();
    final cols = a.read(collectionRepositoryProvider);
    final links = a.read(linkRepositoryProvider);
    final design = await cols.create('Design', colorHex: '#FF9FC4', icon: 'heart');
    await links.add('https://example.com/1', collectionId: design);
    await links.add('https://example.com/2');
    await Future<void>.delayed(const Duration(milliseconds: 50));
    final file = BackupFormat.toJson(await a.read(dataRepositoryProvider).exportAll());
    a.dispose();

    final b = await app(); // "reinstalled": empty database
    final r = await b
        .read(dataRepositoryProvider)
        .import(BackupFormat.fromJson(file));
    expect(r.imported, 2);
    expect(r.skipped, 0);
    final restored = await b.read(linkRepositoryProvider).watchLinks().first;
    expect(restored.map((l) => l.title).toSet(), {'Page /1', 'Page /2'});
    final c = (await b.read(collectionRepositoryProvider).watchAll().first).single;
    expect(c.name, 'Design');
    expect(c.icon, 'heart');
    expect(restored.firstWhere((l) => l.url.endsWith('/1')).collectionId, c.id);
    b.dispose();
  });

  test('"Add to my links" skips duplicates and reuses collections', () async {
    final c = await app();
    addTearDown(c.dispose);
    final data = c.read(dataRepositoryProvider);
    await c.read(collectionRepositoryProvider).create('design', colorHex: '#FF9FC4');
    await c.read(linkRepositoryProvider).add('https://example.com/a');
    final r = await data.import(const BackupData(
      collections: [BackupCollection(id: 9, name: 'Design')],
      links: [
        BackupLink(url: 'https://www.example.com/a/', collectionId: 9),
        BackupLink(url: 'https://example.com/b', collectionId: 9),
        BackupLink(url: 'https://example.com/b'),
        BackupLink(url: 'not a link'),
      ],
    ));
    expect(r.imported, 1);
    expect(r.skipped, 3);
    expect(await c.read(collectionRepositoryProvider).watchAll().first,
        hasLength(1));
  });

  test('"Replace everything" removes current links first', () async {
    final c = await app();
    addTearDown(c.dispose);
    await c.read(linkRepositoryProvider).add('https://example.com/old');
    final r = await c.read(dataRepositoryProvider).import(
        const BackupData(collections: [], links: [BackupLink(url: 'https://example.com/new')]),
        replace: true);
    expect(r.imported, 1);
    final all = await c.read(linkRepositoryProvider).watchLinks().first;
    expect(all.single.url, 'https://example.com/new');
  });
}
