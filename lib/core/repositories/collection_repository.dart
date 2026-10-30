import 'dart:ui';

import 'package:drift/drift.dart';

import '../db/database.dart';
import '../models/collection_item.dart';

class CollectionRepository {
  CollectionRepository(this._db);

  final AppDatabase _db;

  /// Pinned first, then manual order, then name.
  Stream<List<CollectionItem>> watchAll() {
    final q = _db.select(_db.collections)
      ..orderBy([
        (c) => OrderingTerm.desc(c.pinned),
        (c) => OrderingTerm.asc(c.sortOrder),
        (c) => OrderingTerm.asc(c.name),
      ]);
    return q.watch().map((rows) => rows.map(_toItem).toList());
  }

  Future<int> create(String name, {required String colorHex, String icon = 'star'}) =>
      _db.into(_db.collections).insert(CollectionsCompanion.insert(
            name: name.trim(),
            color: colorHex,
            icon: Value(icon),
            createdAt: DateTime.now().toUtc(),
          ));

  static CollectionItem _toItem(Collection r) => CollectionItem(
        id: r.id,
        name: r.name,
        color: _hex(r.color),
        icon: r.icon,
        pinned: r.pinned,
      );

  static Color _hex(String hex) =>
      Color(int.parse(hex.replaceFirst('#', ''), radix: 16) | 0xFF000000);
}
