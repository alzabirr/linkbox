import 'package:drift/drift.dart';

import '../db/database.dart';
import '../models/link_item.dart';
import '../models/link_sort.dart';
import '../services/metadata_parser.dart';
import '../services/metadata_service.dart';
import '../utils/url_normalizer.dart';
import '../widgets/scene_art.dart';

/// Thrown when the link is already saved.
class DuplicateLinkException implements Exception {
  const DuplicateLinkException(this.existing);
  final LinkItem existing;
}

class LinkRepository {
  LinkRepository(this._db, this._metadata, this._queue);

  final AppDatabase _db;
  final MetadataService _metadata;
  final FetchQueue _queue;

  /// Soft-deleted links are hidden. [collectionId] filters; [query]
  /// matches the title or the link (case-insensitive).
  Stream<List<LinkItem>> watchLinks({
    int? collectionId,
    LinkSort sort = LinkSort.newest,
    String query = '',
  }) {
    final q = _db.select(_db.links)..where((l) => l.deletedAt.isNull());
    if (collectionId != null) {
      q.where((l) => l.collectionId.equals(collectionId));
    }
    final words = query.trim().toLowerCase();
    if (words.isNotEmpty) {
      final like = '%${words.replaceAll('%', r'\%').replaceAll('_', r'\_')}%';
      q.where((l) =>
          l.title.lower().like(like) |
          l.url.lower().like(like) |
          l.domain.like(like));
    }
    // Links without a title sort by their address.
    final name = coalesce<String>([_db.links.title, _db.links.domain]).lower();
    q.orderBy([
      switch (sort) {
        LinkSort.newest => (l) => OrderingTerm.desc(l.createdAt),
        LinkSort.oldest => (l) => OrderingTerm.asc(l.createdAt),
        LinkSort.az => (_) => OrderingTerm.asc(name),
        LinkSort.za => (_) => OrderingTerm.desc(name),
      },
      (l) => sort == LinkSort.oldest
          ? OrderingTerm.asc(l.id)
          : OrderingTerm.desc(l.id),
    ]);
    return q.watch().map((rows) => rows.map(_toItem).toList());
  }

  /// One link, live (Quick look, Edit). Null once it is deleted.
  Stream<LinkItem?> watchLink(int id) => (_db.select(_db.links)
        ..where((l) => l.id.equals(id) & l.deletedAt.isNull()))
      .watchSingleOrNull()
      .map((r) => r == null ? null : _toItem(r));

  /// Saves the Edit link page (08).
  Future<void> updateDetails(
    int id, {
    required String? title,
    required String? description,
    required String? imageUrl,
    required String? customImagePath,
  }) =>
      (_db.update(_db.links)..where((l) => l.id.equals(id))).write(
        LinksCompanion(
          title: Value(_blankToNull(title)),
          description: Value(_blankToNull(description)),
          imageUrl: Value(imageUrl),
          customImagePath: Value(customImagePath),
          fetchStatus: Value(FetchStatus.ok.name),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );

  /// Hides links at once; [purgeDeleted] removes them for good.
  Future<void> softDelete(List<int> ids) =>
      (_db.update(_db.links)..where((l) => l.id.isIn(ids))).write(
          LinksCompanion(deletedAt: Value(DateTime.now().toUtc())));

  /// "Undo" on the undo bar (29).
  Future<void> undoDelete(List<int> ids) =>
      (_db.update(_db.links)..where((l) => l.id.isIn(ids)))
          .write(const LinksCompanion(deletedAt: Value(null)));

  /// Deletes soft-deleted rows ([ids], or all of them on app start).
  Future<void> purgeDeleted([List<int>? ids]) =>
      (_db.delete(_db.links)
            ..where((l) => ids == null
                ? l.deletedAt.isNotNull()
                : l.deletedAt.isNotNull() & l.id.isIn(ids)))
          .go();

  Future<LinkItem?> findByUrl(String url) async {
    final row = await (_db.select(_db.links)
          ..where((l) =>
              l.normalizedUrl.equals(UrlUtils.normalize(url)) &
              l.deletedAt.isNull()))
        .getSingleOrNull();
    return row == null ? null : _toItem(row);
  }

  Future<LinkItem?> findById(int id) async {
    final row = await (_db.select(_db.links)..where((l) => l.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toItem(row);
  }

  /// Saves a link at once. With [meta] (preview already shown in the Add
  /// sheet) it is stored as-is; otherwise the preview is fetched afterwards
  /// and [title] (e.g. the page title another app shared) is shown meanwhile.
  /// [allowDuplicate] is "Save a copy" (07).
  Future<int> add(
    String url, {
    int? collectionId,
    LinkMetadata? meta,
    String? title,
    bool allowDuplicate = false,
  }) async {
    final clean = url.trim();
    if (!allowDuplicate) {
      final existing = await findByUrl(clean);
      if (existing != null) throw DuplicateLinkException(existing);
    }

    final now = DateTime.now().toUtc();
    final id = await _db.into(_db.links).insert(LinksCompanion.insert(
          url: clean,
          normalizedUrl: UrlUtils.normalize(clean),
          domain: UrlUtils.domainOf(clean),
          title: Value(meta?.title ?? _cleanTitle(title, clean)),
          description: Value(meta?.description),
          imageUrl: Value(meta?.imageUrl),
          siteName: Value(meta?.siteName),
          kind: Value((meta?.kind ?? MetadataParser.kindFor(clean)).name),
          collectionId: Value(collectionId),
          fetchStatus: Value(
              meta == null ? FetchStatus.pending.name : FetchStatus.ok.name),
          createdAt: now,
          updatedAt: now,
        ));
    if (meta == null) _queueFetch(id, clean);
    return id;
  }

  /// Puts links into a collection (null = "No collection").
  Future<void> moveLinks(List<int> ids, int? collectionId) =>
      (_db.update(_db.links)..where((l) => l.id.isIn(ids))).write(
          LinksCompanion(
              collectionId: Value(collectionId),
              updatedAt: Value(DateTime.now().toUtc())));

  /// Number of links per collection id (null key = no collection).
  Stream<Map<int?, int>> watchCounts() {
    final count = _db.links.id.count();
    final q = _db.selectOnly(_db.links)
      ..addColumns([_db.links.collectionId, count])
      ..where(_db.links.deletedAt.isNull())
      ..groupBy([_db.links.collectionId]);
    return q.watch().map((rows) => {
          for (final r in rows)
            r.read(_db.links.collectionId): r.read(count) ?? 0,
        });
  }

  /// "Try again" on a failed card.
  Future<void> retry(int id) async {
    final row = await (_db.select(_db.links)..where((l) => l.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return;
    await _setStatus(id, FetchStatus.pending);
    _queueFetch(id, row.url);
  }

  /// Fetch previews that never finished (e.g. saved while offline).
  Future<void> resumePending() async {
    final rows = await (_db.select(_db.links)
          ..where((l) =>
              l.fetchStatus.equals(FetchStatus.pending.name) &
              l.deletedAt.isNull()))
        .get();
    for (final r in rows) {
      _queueFetch(r.id, r.url);
    }
  }

  static String? _blankToNull(String? s) {
    final t = s?.trim();
    return t == null || t.isEmpty ? null : t;
  }

  /// A shared subject that is just the link again is not a title.
  static String? _cleanTitle(String? title, String url) {
    final t = title?.trim();
    if (t == null || t.isEmpty || t.contains('://') || t == url) return null;
    return t.length > MetadataParser.maxTitle
        ? t.substring(0, MetadataParser.maxTitle)
        : t;
  }

  void _queueFetch(int id, String url) {
    _queue.add(id, () async {
      try {
        final meta = await _metadata.fetch(url);
        await (_db.update(_db.links)..where((l) => l.id.equals(id))).write(
          LinksCompanion(
            title: meta.title == null ? const Value.absent() : Value(meta.title),
            description: Value(meta.description),
            imageUrl: Value(meta.imageUrl),
            siteName: Value(meta.siteName),
            kind: Value(meta.kind.name),
            fetchStatus: Value(FetchStatus.ok.name),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );
      } on MetadataException catch (e) {
        // Offline: stay "pending" and try again on the next start.
        if (!e.offline) await _setStatus(id, FetchStatus.failed);
      }
    });
  }

  Future<void> _setStatus(int id, FetchStatus s) =>
      (_db.update(_db.links)..where((l) => l.id.equals(id))).write(
          LinksCompanion(
              fetchStatus: Value(s.name),
              updatedAt: Value(DateTime.now().toUtc())));

  static LinkItem _toItem(Link r) => LinkItem(
        id: r.id,
        url: r.url,
        domain: r.domain,
        kind: LinkKind.values.asNameMap()[r.kind] ?? LinkKind.other,
        fetchStatus:
            FetchStatus.values.asNameMap()[r.fetchStatus] ?? FetchStatus.pending,
        createdAt: r.createdAt,
        title: r.title,
        description: r.description,
        imageUrl: r.imageUrl,
        customImagePath: r.customImagePath,
        siteName: r.siteName,
        collectionId: r.collectionId,
      );
}
