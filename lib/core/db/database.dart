import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Links, Collections])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ??
            driftDatabase(
              name: 'linkbox',
              // The share overlay runs a second Flutter engine; sharing one
              // database isolate keeps both screens in sync.
              native: const DriftNativeOptions(shareAcrossIsolates: true),
            ));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v2: normalized_url is no longer unique, only indexed.
            await m.alterTable(TableMigration(links));
            await m.create(linksNormalizedUrl);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
