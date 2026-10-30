import 'package:drift/drift.dart';

@TableIndex(name: 'links_collection_id', columns: {#collectionId})
@TableIndex(name: 'links_created_at', columns: {#createdAt})
@TableIndex(name: 'links_title', columns: {#title})
class Links extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Exactly as shared or typed.
  TextColumn get url => text()();

  /// For the duplicate check (see url_normalizer.dart).
  TextColumn get normalizedUrl => text().unique()();
  TextColumn get title => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get customImagePath => text().nullable()();
  TextColumn get siteName => text().nullable()();
  TextColumn get domain => text()();

  /// video / article / post / other
  TextColumn get kind => text().withDefault(const Constant('other'))();
  IntColumn get collectionId => integer()
      .nullable()
      .references(Collections, #id, onDelete: KeyAction.setNull)();

  /// pending / ok / failed
  TextColumn get fetchStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

class Collections extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Max 30, unique ignoring case.
  TextColumn get name =>
      text().customConstraint('NOT NULL UNIQUE COLLATE NOCASE')();

  /// Hex from the palette, e.g. #FF9FC4.
  TextColumn get color => text()();

  /// star, code, book, plane, home, music
  TextColumn get icon => text().withDefault(const Constant('star'))();
  BoolColumn get pinned => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
}
