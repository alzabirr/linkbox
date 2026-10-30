import 'package:drift/drift.dart';

import '../db/database.dart';
import '../models/link_item.dart';
import '../services/backup_format.dart';
import '../services/metadata_parser.dart';
import '../utils/url_normalizer.dart';
import 'link_repository.dart';

/// How many links an import or restore added and skipped.
class ImportResult {
  const ImportResult(this.imported, this.skipped);
  final int imported;
  final int skipped;
}

/// Backup, restore, import and export (14, 28).
class DataRepository {
  DataRepository(this._db, this._links);

  final AppDatabase _db;
  final LinkRepository _links;

  static const _palette = [
    '#FF9FC4', '#7CC4FF', '#FFD23F', '#7DDBA3', '#B79CFF', '#FF9F6B',
  ];

  /// Everything that is not deleted, ready to write to a file.
  Future<BackupData> exportAll() async {
    final cols = await _db.select(_db.collections).get();
    final links = await (_db.select(_db.links)
          ..where((l) => l.deletedAt.isNull())
          ..orderBy([(l) => OrderingTerm.asc(l.createdAt)]))
        .get();
    return BackupData(
      exportedAt: DateTime.now().toUtc(),
      collections: [
        for (final c in cols)
          BackupCollection(
              id: c.id,
              name: c.name,
              color: c.color,
              icon: c.icon,
              pinned: c.pinned),
      ],
      links: [
        for (final l in links)
          BackupLink(
            url: l.url,
            title: l.title,
            description: l.description,
            imageUrl: l.imageUrl,
            siteName: l.siteName,
            kind: l.kind,
            collectionId: l.collectionId,
            createdAt: l.createdAt,
          ),
      ],
    );
  }

  /// Adds [data] in one transaction. Links already saved are skipped;
  /// collections are matched by name. With [replace], everything is
  /// removed first. Previews are fetched afterwards for links without one.
  Future<ImportResult> import(BackupData data, {bool replace = false}) async {
    final result = await _db.transaction(() async {
      if (replace) {
        await _db.delete(_db.links).go();
        await _db.delete(_db.collections).go();
      }
      final existing = await _db.select(_db.collections).get();
      final byName = {for (final c in existing) c.name.toLowerCase(): c.id};
      final colIds = <int, int>{}; // backup id → new id
      var colorIndex = existing.length;
      for (final c in data.collections) {
        var name = c.name.trim();
        if (name.length > 30) name = name.substring(0, 30);
        final key = name.toLowerCase();
        colIds[c.id] = byName[key] ??= await _db.into(_db.collections).insert(
              CollectionsCompanion.insert(
                name: name,
                color: c.color ?? _palette[colorIndex++ % _palette.length],
                icon: Value(c.icon ?? 'star'),
                pinned: Value(c.pinned),
                createdAt: DateTime.now().toUtc(),
              ),
            );
      }

      final saved = (await (_db.selectOnly(_db.links)
                ..addColumns([_db.links.normalizedUrl])
                ..where(_db.links.deletedAt.isNull()))
              .get())
          .map((r) => r.read(_db.links.normalizedUrl)!)
          .toSet();
      var imported = 0, skipped = 0;
      final now = DateTime.now().toUtc();
      await _db.batch((b) {
        for (final l in data.links) {
          final key = UrlUtils.normalize(l.url);
          if (!UrlUtils.isValid(l.url) || !saved.add(key)) {
            skipped++;
            continue;
          }
          final hasPreview = l.imageUrl != null || l.description != null;
          final title = l.title;
          b.insert(
            _db.links,
            LinksCompanion.insert(
              url: l.url.trim(),
              normalizedUrl: key,
              domain: UrlUtils.domainOf(l.url),
              title: Value(title == null || title.length <= MetadataParser.maxTitle
                  ? title
                  : title.substring(0, MetadataParser.maxTitle)),
              description: Value(l.description),
              imageUrl: Value(l.imageUrl),
              siteName: Value(l.siteName),
              kind: Value(l.kind ?? MetadataParser.kindFor(l.url).name),
              collectionId: Value(colIds[l.collectionId]),
              fetchStatus: Value(hasPreview
                  ? FetchStatus.ok.name
                  : FetchStatus.pending.name),
              createdAt: l.createdAt ?? now,
              updatedAt: now,
            ),
          );
          imported++;
        }
      });
      return ImportResult(imported, skipped);
    });
    await _links.resumePending();
    return result;
  }

  /// Links saved right now (for "Your current 89 links are removed first").
  Future<int> linkCount() async {
    final count = _db.links.id.count();
    final row = await (_db.selectOnly(_db.links)
          ..addColumns([count])
          ..where(_db.links.deletedAt.isNull()))
        .getSingle();
    return row.read(count) ?? 0;
  }
}
