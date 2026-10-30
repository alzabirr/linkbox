import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/models/collection_item.dart';
import '../../core/models/link_item.dart';
import '../../core/models/link_sort.dart';
import '../../core/providers.dart';
import '../../core/repositories/collection_repository.dart';

part 'links_providers.g.dart';

enum ViewMode { grid, list }

/// Grid or list on Home; saved in settings (`view_mode`).
@riverpod
class HomeViewMode extends _$HomeViewMode {
  static const _key = 'view_mode';

  @override
  ViewMode build() {
    final saved = ref.watch(sharedPrefsProvider).getString(_key);
    return ViewMode.values.asNameMap()[saved] ?? ViewMode.grid;
  }

  void toggle() {
    state = state == ViewMode.grid ? ViewMode.list : ViewMode.grid;
    ref.read(sharedPrefsProvider).setString(_key, state.name);
  }
}

/// Collection chip picked on Home; null = "All".
@riverpod
class HomeCollectionFilter extends _$HomeCollectionFilter {
  @override
  int? build() => null;

  void select(int? id) => state = id;
}

@riverpod
Stream<List<CollectionItem>> collections(Ref ref) =>
    ref.watch(collectionRepositoryProvider).watchAll();

/// Sort order, saved in settings (`sort`).
@riverpod
class LinkSortSetting extends _$LinkSortSetting {
  static const _key = 'sort';

  @override
  LinkSort build() =>
      LinkSort.values.asNameMap()[ref.watch(sharedPrefsProvider).getString(_key)] ??
      LinkSort.newest;

  void set(LinkSort sort) {
    state = sort;
    ref.read(sharedPrefsProvider).setString(_key, sort.name);
  }
}

/// Links shown on Home (respects the collection chip and sort).
@riverpod
Stream<List<LinkItem>> homeLinks(Ref ref) {
  final filter = ref.watch(homeCollectionFilterProvider);
  final sort = ref.watch(linkSortSettingProvider);
  return ref
      .watch(linkRepositoryProvider)
      .watchLinks(collectionId: filter, sort: sort);
}

/// Text typed on the search page (03).
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void set(String q) => state = q;
}

/// "All collections" pill on the search page; null = all.
@riverpod
class SearchCollection extends _$SearchCollection {
  @override
  int? build() => null;

  void set(int? id) => state = id;
}

@riverpod
Stream<List<LinkItem>> searchResults(Ref ref) => ref
    .watch(linkRepositoryProvider)
    .watchLinks(
      collectionId: ref.watch(searchCollectionProvider),
      sort: ref.watch(linkSortSettingProvider),
      query: ref.watch(searchQueryProvider),
    );

/// One link, live; null once deleted.
@riverpod
Stream<LinkItem?> link(Ref ref, int id) =>
    ref.watch(linkRepositoryProvider).watchLink(id);

/// What the undo bar (29) shows.
class PendingDelete {
  const PendingDelete(this.ids, this.startedAt);
  final List<int> ids;
  final DateTime startedAt;
}

/// Soft delete + 5 s Undo, then the rows are removed for good.
@Riverpod(keepAlive: true)
class UndoDelete extends _$UndoDelete {
  static const window = Duration(seconds: 5);
  Timer? _timer;

  @override
  PendingDelete? build() {
    ref.onDispose(() => _timer?.cancel());
    return null;
  }

  Future<void> delete(List<int> ids) async {
    final previous = state;
    if (previous != null) await _purge(previous.ids);
    await ref.read(linkRepositoryProvider).softDelete(ids);
    state = PendingDelete(ids, DateTime.now());
    _timer?.cancel();
    _timer = Timer(window, () => _purge(ids));
  }

  Future<void> undo() async {
    final pending = state;
    if (pending == null) return;
    _timer?.cancel();
    state = null;
    await ref.read(linkRepositoryProvider).undoDelete(pending.ids);
  }

  Future<void> _purge(List<int> ids) async {
    if (state?.ids == ids) state = null;
    await ref.read(linkRepositoryProvider).purgeDeleted(ids);
  }
}

/// Total number of saved links (for the empty state).
@riverpod
Stream<int> linkCount(Ref ref) => ref
    .watch(linkRepositoryProvider)
    .watchLinks()
    .map((links) => links.length);

/// Runs once at start: remove links deleted last time (Undo has expired)
/// and finish previews that were left pending.
@Riverpod(keepAlive: true)
Future<void> startup(Ref ref) async {
  final repo = ref.read(linkRepositoryProvider);
  await repo.purgeDeleted();
  await repo.resumePending();
}

/// Links per collection id (null key = no collection).
@riverpod
Stream<Map<int?, int>> collectionCounts(Ref ref) =>
    ref.watch(linkRepositoryProvider).watchCounts();

/// Count and last change per collection.
@riverpod
Stream<Map<int, CollectionStats>> collectionStats(Ref ref) =>
    ref.watch(collectionRepositoryProvider).watchStats();

@riverpod
Stream<CollectionItem?> collection(Ref ref, int id) =>
    ref.watch(collectionRepositoryProvider).watchOne(id);

/// Links in one collection (19), with the shared sort.
@riverpod
Stream<List<LinkItem>> collectionLinks(Ref ref, int id) => ref
    .watch(linkRepositoryProvider)
    .watchLinks(collectionId: id, sort: ref.watch(linkSortSettingProvider));

/// Multi-select (10): ids of the selected links; empty = not selecting.
@Riverpod(keepAlive: true)
class Selection extends _$Selection {
  @override
  Set<int> build() => const {};

  void start(int id) => state = {id};

  void toggle(int id) => state = state.contains(id)
      ? ({...state}..remove(id))
      : {...state, id};

  void selectAll(Iterable<int> ids) => state = {...ids};

  void clear() => state = const {};
}
