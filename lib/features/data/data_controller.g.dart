// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// When the last backup was written (`last_backup_at`).

@ProviderFor(LastBackup)
final lastBackupProvider = LastBackupProvider._();

/// When the last backup was written (`last_backup_at`).
final class LastBackupProvider
    extends $NotifierProvider<LastBackup, DateTime?> {
  /// When the last backup was written (`last_backup_at`).
  LastBackupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastBackupProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastBackupHash();

  @$internal
  @override
  LastBackup create() => LastBackup();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime?>(value),
    );
  }
}

String _$lastBackupHash() => r'f58f45158bbede913b27cddeaa6ce70db65abdb2';

/// When the last backup was written (`last_backup_at`).

abstract class _$LastBackup extends $Notifier<DateTime?> {
  DateTime? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DateTime?, DateTime?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime?, DateTime?>,
              DateTime?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(dataActions)
final dataActionsProvider = DataActionsProvider._();

final class DataActionsProvider
    extends $FunctionalProvider<DataActions, DataActions, DataActions>
    with $Provider<DataActions> {
  DataActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dataActionsHash();

  @$internal
  @override
  $ProviderElement<DataActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DataActions create(Ref ref) {
    return dataActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DataActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DataActions>(value),
    );
  }
}

String _$dataActionsHash() => r'd5b772e5f666d9985ebd2753c424bd1941e4f118';
