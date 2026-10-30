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

/// Links shown on Home (respects the collection chip).

@ProviderFor(homeLinks)
final homeLinksProvider = HomeLinksProvider._();

/// Links shown on Home (respects the collection chip).

final class HomeLinksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LinkItem>>,
          List<LinkItem>,
          Stream<List<LinkItem>>
        >
    with $FutureModifier<List<LinkItem>>, $StreamProvider<List<LinkItem>> {
  /// Links shown on Home (respects the collection chip).
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

String _$homeLinksHash() => r'643c02c247e16b307ca36606057b7d3a442a5317';

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

/// Runs once at start: finish previews that were left pending.

@ProviderFor(startup)
final startupProvider = StartupProvider._();

/// Runs once at start: finish previews that were left pending.

final class StartupProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Runs once at start: finish previews that were left pending.
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

String _$startupHash() => r'da16e0a6baf365124e200d7e6a5fd4c7ba23ba96';
