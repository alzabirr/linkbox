import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/models/collection_item.dart';
import '../../core/models/link_item.dart';
import '../../core/providers.dart';

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

/// Links shown on Home (respects the collection chip).
@riverpod
Stream<List<LinkItem>> homeLinks(Ref ref) {
  final filter = ref.watch(homeCollectionFilterProvider);
  return ref.watch(linkRepositoryProvider).watchLinks(collectionId: filter);
}

/// Total number of saved links (for the empty state).
@riverpod
Stream<int> linkCount(Ref ref) => ref
    .watch(linkRepositoryProvider)
    .watchLinks()
    .map((links) => links.length);

/// Runs once at start: finish previews that were left pending.
@Riverpod(keepAlive: true)
Future<void> startup(Ref ref) =>
    ref.read(linkRepositoryProvider).resumePending();
