import 'dart:ui';

import 'package:drift/drift.dart';

import '../db/database.dart';
import '../models/collection_item.dart';

/// Thrown when another collection already has that name (any case).
class DuplicateCollectionException implements Exception {
  const DuplicateCollectionException();
}

/// Link count and last change per collection (12, 19).
class CollectionStats {
  const CollectionStats(this.count, this.updatedAt);
  final int count;

  /// UTC; null when the collection has no links.
  final DateTime? updatedAt;
}

class CollectionRepository {
  CollectionRepository(this._db);

  final AppDatabase _db;

  static const maxName = 30;

  /// Pinned first, then manual order, then name.
  Stream<List<CollectionItem>> watchAll() {
    final q = _db.select(_db.collections)
      ..orderBy([
        (c) => OrderingTerm.desc(c.pinned),
        (c) => OrderingTerm.asc(c.sortOrder),
        (c) => OrderingTerm(expression: c.name.collate(Collate.noCase)),
      ]);
    return q.watch().map((rows) => rows.map(_toItem).toList());
  }

  Stream<CollectionItem?> watchOne(int id) =>
      (_db.select(_db.collections)..where((c) => c.id.equals(id)))
          .watchSingleOrNull()
          .map((r) => r == null ? null : _toItem(r));

  /// Count and newest change per collection (soft-deleted links excluded).
  Stream<Map<int, CollectionStats>> watchStats() {
    final l = _db.links;
    final count = l.id.count();
    final newest = l.updatedAt.max();
    final q = _db.selectOnly(l)
      ..addColumns([l.collectionId, count, newest])
      ..where(l.deletedAt.isNull() & l.collectionId.isNotNull())
      ..groupBy([l.collectionId]);
    return q.watch().map((rows) => {
          for (final r in rows)
            r.read(l.collectionId)!:
                CollectionStats(r.read(count) ?? 0, r.read(newest)),
        });
  }

  Future<int> create(String name,
      {required String colorHex, String icon = 'star'}) async {
    await _checkName(name);
    return _db.into(_db.collections).insert(CollectionsCompanion.insert(
          name: _clean(name),
          color: colorHex,
          icon: Value(icon),
          createdAt: DateTime.now().toUtc(),
        ));
  }

  /// Rename / change color & icon (20 in rename mode).
  Future<void> update(int id,
      {required String name,
      required String colorHex,
      required String icon}) async {
    await _checkName(name, except: id);
    await (_db.update(_db.collections)..where((c) => c.id.equals(id))).write(
        CollectionsCompanion(
            name: Value(_clean(name)),
            color: Value(colorHex),
            icon: Value(icon)));
  }

  Future<void> setPinned(int id, bool pinned) =>
      (_db.update(_db.collections)..where((c) => c.id.equals(id)))
          .write(CollectionsCompanion(pinned: Value(pinned)));

  /// Links move to "No collection"; nothing else is lost.
  Future<void> delete(int id) => _db.transaction(() async {
        await (_db.update(_db.links)..where((l) => l.collectionId.equals(id)))
            .write(const LinksCompanion(collectionId: Value(null)));
        await (_db.delete(_db.collections)..where((c) => c.id.equals(id)))
            .go();
      });

  Future<void> _checkName(String name, {int? except}) async {
    final clean = _clean(name).toLowerCase();
    final rows = await _db.select(_db.collections).get();
    if (rows.any((r) => r.id != except && r.name.toLowerCase() == clean)) {
      throw const DuplicateCollectionException();
    }
  }

  static String _clean(String name) {
    final t = name.trim();
    return t.length > maxName ? t.substring(0, maxName) : t;
  }

  static CollectionItem _toItem(Collection r) => CollectionItem(
        id: r.id,
        name: r.name,
        color: _hex(r.color),
        icon: r.icon,
        pinned: r.pinned,
        createdAt: r.createdAt,
      );

  static Color _hex(String hex) =>
      Color(int.parse(hex.replaceFirst('#', ''), radix: 16) | 0xFF000000);

  /// "#FF9FC4" for storage.
  static String toHex(Color c) =>
      '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
