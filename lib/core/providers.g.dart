// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(database)
final databaseProvider = DatabaseProvider._();

final class DatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  DatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$databaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return database(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$databaseHash() => r'0fe56aaf5bde72ce9021e425b918c495557124c1';

@ProviderFor(httpClient)
final httpClientProvider = HttpClientProvider._();

final class HttpClientProvider
    extends $FunctionalProvider<http.Client, http.Client, http.Client>
    with $Provider<http.Client> {
  HttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'httpClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$httpClientHash();

  @$internal
  @override
  $ProviderElement<http.Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  http.Client create(Ref ref) {
    return httpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(http.Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<http.Client>(value),
    );
  }
}

String _$httpClientHash() => r'7ec49beae0f15115de79f9aa98dbd250130e26d8';

@ProviderFor(metadataService)
final metadataServiceProvider = MetadataServiceProvider._();

final class MetadataServiceProvider
    extends
        $FunctionalProvider<MetadataService, MetadataService, MetadataService>
    with $Provider<MetadataService> {
  MetadataServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'metadataServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$metadataServiceHash();

  @$internal
  @override
  $ProviderElement<MetadataService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MetadataService create(Ref ref) {
    return metadataService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MetadataService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MetadataService>(value),
    );
  }
}

String _$metadataServiceHash() => r'b50423e3e5321475bc20667b8b0669748f414259';

@ProviderFor(linkRepository)
final linkRepositoryProvider = LinkRepositoryProvider._();

final class LinkRepositoryProvider
    extends $FunctionalProvider<LinkRepository, LinkRepository, LinkRepository>
    with $Provider<LinkRepository> {
  LinkRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'linkRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkRepositoryHash();

  @$internal
  @override
  $ProviderElement<LinkRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LinkRepository create(Ref ref) {
    return linkRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LinkRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LinkRepository>(value),
    );
  }
}

String _$linkRepositoryHash() => r'b07dce7ecf456fc488edb6b150d86de8d21f3196';

@ProviderFor(collectionRepository)
final collectionRepositoryProvider = CollectionRepositoryProvider._();

final class CollectionRepositoryProvider
    extends
        $FunctionalProvider<
          CollectionRepository,
          CollectionRepository,
          CollectionRepository
        >
    with $Provider<CollectionRepository> {
  CollectionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionRepositoryHash();

  @$internal
  @override
  $ProviderElement<CollectionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CollectionRepository create(Ref ref) {
    return collectionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CollectionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CollectionRepository>(value),
    );
  }
}

String _$collectionRepositoryHash() =>
    r'61a383d72e58e3da5589c6b3b35486e29ba18b0a';

@ProviderFor(dataRepository)
final dataRepositoryProvider = DataRepositoryProvider._();

final class DataRepositoryProvider
    extends $FunctionalProvider<DataRepository, DataRepository, DataRepository>
    with $Provider<DataRepository> {
  DataRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dataRepositoryHash();

  @$internal
  @override
  $ProviderElement<DataRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DataRepository create(Ref ref) {
    return dataRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DataRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DataRepository>(value),
    );
  }
}

String _$dataRepositoryHash() => r'10f0c7ccb784182db06b6ec6052047df4c12fe0e';

@ProviderFor(fileStore)
final fileStoreProvider = FileStoreProvider._();

final class FileStoreProvider
    extends $FunctionalProvider<FileStore, FileStore, FileStore>
    with $Provider<FileStore> {
  FileStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileStoreHash();

  @$internal
  @override
  $ProviderElement<FileStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FileStore create(Ref ref) {
    return fileStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileStore>(value),
    );
  }
}

String _$fileStoreHash() => r'0da29fbc0de93a330169ed3907ca891bca05f760';
