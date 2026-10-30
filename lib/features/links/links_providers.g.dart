// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'links_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Grid or list on Home; saved in settings (`view_mode`).

@ProviderFor(HomeViewMode)
final homeViewModeProvider = HomeViewModeProvider._();

/// Grid or list on Home; saved in settings (`view_mode`).
final class HomeViewModeProvider
    extends $NotifierProvider<HomeViewMode, ViewMode> {
  /// Grid or list on Home; saved in settings (`view_mode`).
  HomeViewModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeViewModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeViewModeHash();

  @$internal
  @override
  HomeViewMode create() => HomeViewMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ViewMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ViewMode>(value),
    );
  }
}

String _$homeViewModeHash() => r'f309885398a983da1d61f28141e47c0f66b30f5f';

/// Grid or list on Home; saved in settings (`view_mode`).

abstract class _$HomeViewMode extends $Notifier<ViewMode> {
  ViewMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ViewMode, ViewMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ViewMode, ViewMode>,
              ViewMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Collection chip picked on Home; null = "All".

@ProviderFor(HomeCollectionFilter)
final homeCollectionFilterProvider = HomeCollectionFilterProvider._();

/// Collection chip picked on Home; null = "All".
final class HomeCollectionFilterProvider
    extends $NotifierProvider<HomeCollectionFilter, int?> {
  /// Collection chip picked on Home; null = "All".
  HomeCollectionFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeCollectionFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeCollectionFilterHash();

  @$internal
  @override
  HomeCollectionFilter create() => HomeCollectionFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$homeCollectionFilterHash() =>
    r'e90851a394533bda6fdaec308d6a27c170017408';

/// Collection chip picked on Home; null = "All".

abstract class _$HomeCollectionFilter extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(collections)
final collectionsProvider = CollectionsProvider._();

final class CollectionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CollectionItem>>,
          List<CollectionItem>,
          Stream<List<CollectionItem>>
        >
    with
        $FutureModifier<List<CollectionItem>>,
        $StreamProvider<List<CollectionItem>> {
  CollectionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionsHash();

  @$internal
  @override
  $StreamProviderElement<List<CollectionItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CollectionItem>> create(Ref ref) {
    return collections(ref);
  }
}

String _$collectionsHash() => r'd43329a4e213c63f054b6a4abc4bccc67d31ab7a';

/// Sort order, saved in settings (`sort`).

@ProviderFor(LinkSortSetting)
final linkSortSettingProvider = LinkSortSettingProvider._();

/// Sort order, saved in settings (`sort`).
final class LinkSortSettingProvider
    extends $NotifierProvider<LinkSortSetting, LinkSort> {
  /// Sort order, saved in settings (`sort`).
  LinkSortSettingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'linkSortSettingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkSortSettingHash();

  @$internal
  @override
  LinkSortSetting create() => LinkSortSetting();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LinkSort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LinkSort>(value),
    );
  }
}

String _$linkSortSettingHash() => r'54002311801e303ae4558e4b7f7cfa3052093ed9';

/// Sort order, saved in settings (`sort`).

abstract class _$LinkSortSetting extends $Notifier<LinkSort> {
  LinkSort build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LinkSort, LinkSort>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LinkSort, LinkSort>,
              LinkSort,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Links shown on Home (respects the collection chip and sort).

@ProviderFor(homeLinks)
final homeLinksProvider = HomeLinksProvider._();

/// Links shown on Home (respects the collection chip and sort).

final class HomeLinksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LinkItem>>,
          List<LinkItem>,
          Stream<List<LinkItem>>
        >
    with $FutureModifier<List<LinkItem>>, $StreamProvider<List<LinkItem>> {
  /// Links shown on Home (respects the collection chip and sort).
  HomeLinksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeLinksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeLinksHash();

  @$internal
  @override
  $StreamProviderElement<List<LinkItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<LinkItem>> create(Ref ref) {
    return homeLinks(ref);
  }
}

String _$homeLinksHash() => r'121c18a4a4ac945f05ed9b8fc86df8da465f4202';

/// Text typed on the search page (03).

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

/// Text typed on the search page (03).
final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  /// Text typed on the search page (03).
  SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'75b81792dd41a5682b782c6d689b882be21e5f73';

/// Text typed on the search page (03).

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// "All collections" pill on the search page; null = all.

@ProviderFor(SearchCollection)
final searchCollectionProvider = SearchCollectionProvider._();

/// "All collections" pill on the search page; null = all.
final class SearchCollectionProvider
    extends $NotifierProvider<SearchCollection, int?> {
  /// "All collections" pill on the search page; null = all.
  SearchCollectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchCollectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchCollectionHash();

  @$internal
  @override
  SearchCollection create() => SearchCollection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$searchCollectionHash() => r'3e15536c82037dbd665f843df413245cadbe04a5';

/// "All collections" pill on the search page; null = all.

abstract class _$SearchCollection extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(searchResults)
final searchResultsProvider = SearchResultsProvider._();

final class SearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LinkItem>>,
          List<LinkItem>,
          Stream<List<LinkItem>>
        >
    with $FutureModifier<List<LinkItem>>, $StreamProvider<List<LinkItem>> {
  SearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @$internal
  @override
  $StreamProviderElement<List<LinkItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<LinkItem>> create(Ref ref) {
    return searchResults(ref);
  }
}

String _$searchResultsHash() => r'5a7fb74a436c17ae0a7032a21d3d91ffb76aa232';

/// One link, live; null once deleted.

@ProviderFor(link)
final linkProvider = LinkFamily._();

/// One link, live; null once deleted.

final class LinkProvider
    extends
        $FunctionalProvider<AsyncValue<LinkItem?>, LinkItem?, Stream<LinkItem?>>
    with $FutureModifier<LinkItem?>, $StreamProvider<LinkItem?> {
  /// One link, live; null once deleted.
  LinkProvider._({required LinkFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'linkProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkHash();

  @override
  String toString() {
    return r'linkProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<LinkItem?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<LinkItem?> create(Ref ref) {
    final argument = this.argument as int;
    return link(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LinkProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$linkHash() => r'e5150517d495596cd5684af0e0d3ccf551289b57';

/// One link, live; null once deleted.

final class LinkFamily extends $Family
    with $FunctionalFamilyOverride<Stream<LinkItem?>, int> {
  LinkFamily._()
    : super(
        retry: null,
        name: r'linkProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One link, live; null once deleted.

  LinkProvider call(int id) => LinkProvider._(argument: id, from: this);

  @override
  String toString() => r'linkProvider';
}

/// Soft delete + 5 s Undo, then the rows are removed for good.

@ProviderFor(UndoDelete)
final undoDeleteProvider = UndoDeleteProvider._();

/// Soft delete + 5 s Undo, then the rows are removed for good.
final class UndoDeleteProvider
    extends $NotifierProvider<UndoDelete, PendingDelete?> {
  /// Soft delete + 5 s Undo, then the rows are removed for good.
  UndoDeleteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'undoDeleteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$undoDeleteHash();

  @$internal
  @override
  UndoDelete create() => UndoDelete();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PendingDelete? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PendingDelete?>(value),
    );
  }
}

String _$undoDeleteHash() => r'e9b84592beeab849e92c3e1d1df96754187e8847';

/// Soft delete + 5 s Undo, then the rows are removed for good.

abstract class _$UndoDelete extends $Notifier<PendingDelete?> {
  PendingDelete? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PendingDelete?, PendingDelete?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PendingDelete?, PendingDelete?>,
              PendingDelete?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Total number of saved links (for the empty state).

@ProviderFor(linkCount)
final linkCountProvider = LinkCountProvider._();

/// Total number of saved links (for the empty state).

final class LinkCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Total number of saved links (for the empty state).
  LinkCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'linkCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkCountHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return linkCount(ref);
  }
}

String _$linkCountHash() => r'5575a143e0732cc8168e1273ff3521f3c74e83c9';

/// Runs once at start: remove links deleted last time (Undo has expired)
/// and finish previews that were left pending.

@ProviderFor(startup)
final startupProvider = StartupProvider._();

/// Runs once at start: remove links deleted last time (Undo has expired)
/// and finish previews that were left pending.

final class StartupProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Runs once at start: remove links deleted last time (Undo has expired)
  /// and finish previews that were left pending.
  StartupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$startupHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return startup(ref);
  }
}

String _$startupHash() => r'ec10cd2225490f64d71961c49419dd07c9cd5790';

/// Links per collection id (null key = no collection).

@ProviderFor(collectionCounts)
final collectionCountsProvider = CollectionCountsProvider._();

/// Links per collection id (null key = no collection).

final class CollectionCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<int?, int>>,
          Map<int?, int>,
          Stream<Map<int?, int>>
        >
    with $FutureModifier<Map<int?, int>>, $StreamProvider<Map<int?, int>> {
  /// Links per collection id (null key = no collection).
  CollectionCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionCountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionCountsHash();

  @$internal
  @override
  $StreamProviderElement<Map<int?, int>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<int?, int>> create(Ref ref) {
    return collectionCounts(ref);
  }
}

String _$collectionCountsHash() => r'8483d0bc49d79cec2f1a3d19dc94c79d6ca046fc';
