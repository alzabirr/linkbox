import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkbox/core/db/database.dart';

/// The M1 (schema v1) tables, with a UNIQUE normalized_url.
const _v1 = [
  'CREATE TABLE "collections" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '"name" TEXT NOT NULL UNIQUE COLLATE NOCASE, "color" TEXT NOT NULL, '
      '"icon" TEXT NOT NULL DEFAULT \'star\', "pinned" INTEGER NOT NULL DEFAULT 0 '
      'CHECK ("pinned" IN (0, 1)), "sort_order" INTEGER NOT NULL DEFAULT 0, '
      '"created_at" TEXT NOT NULL)',
  'CREATE TABLE "links" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '"url" TEXT NOT NULL, "normalized_url" TEXT NOT NULL UNIQUE, "title" TEXT NULL, '
      '"description" TEXT NULL, "image_url" TEXT NULL, "custom_image_path" TEXT NULL, '
      '"site_name" TEXT NULL, "domain" TEXT NOT NULL, "kind" TEXT NOT NULL DEFAULT \'other\', '
      '"collection_id" INTEGER NULL REFERENCES collections (id) ON DELETE SET NULL, '
      '"fetch_status" TEXT NOT NULL DEFAULT \'pending\', "created_at" TEXT NOT NULL, '
      '"updated_at" TEXT NOT NULL, "deleted_at" TEXT NULL)',
  'CREATE INDEX links_collection_id ON links (collection_id)',
  'CREATE INDEX links_created_at ON links (created_at)',
  'CREATE INDEX links_title ON links (title)',
  "INSERT INTO links (url, normalized_url, domain, created_at, updated_at) VALUES "
      "('https://a.com', 'https://a.com', 'a.com', '2026-10-30T10:00:00.000Z', '2026-10-30T10:00:00.000Z')",
  'PRAGMA user_version = 1',
];

void main() {
  test('v1 → v2 keeps links and allows a saved copy', () async {
    final db = AppDatabase(DatabaseConnection(
      NativeDatabase.memory(setup: (raw) {
        for (final sql in _v1) {
          raw.execute(sql);
        }
      }),
      closeStreamsSynchronously: true,
    ));
    final before = await db.select(db.links).get();
    expect(before.single.url, 'https://a.com');

    await db.into(db.links).insert(LinksCompanion.insert(
          url: 'https://a.com',
          normalizedUrl: 'https://a.com',
          domain: 'a.com',
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ));
    expect(await db.select(db.links).get(), hasLength(2));
    await db.close();
  });
}
