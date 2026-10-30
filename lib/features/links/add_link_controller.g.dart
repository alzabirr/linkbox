// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_link_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State of the Add link sheet (06): validation, live preview, collection.

@ProviderFor(AddLinkController)
final addLinkControllerProvider = AddLinkControllerFamily._();

/// State of the Add link sheet (06): validation, live preview, collection.
final class AddLinkControllerProvider
    extends $NotifierProvider<AddLinkController, AddLinkState> {
  /// State of the Add link sheet (06): validation, live preview, collection.
  AddLinkControllerProvider._({
    required AddLinkControllerFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'addLinkControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addLinkControllerHash();

  @override
  String toString() {
    return r'addLinkControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AddLinkController create() => AddLinkController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddLinkState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddLinkState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AddLinkControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addLinkControllerHash() => r'2420b5d8dca0e0ef0ca80244327f06f69c2e1363';

/// State of the Add link sheet (06): validation, live preview, collection.

final class AddLinkControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AddLinkController,
          AddLinkState,
          AddLinkState,
          AddLinkState,
          int?
        > {
  AddLinkControllerFamily._()
    : super(
        retry: null,
        name: r'addLinkControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// State of the Add link sheet (06): validation, live preview, collection.

  AddLinkControllerProvider call(int? initialCollectionId) =>
      AddLinkControllerProvider._(argument: initialCollectionId, from: this);

  @override
  String toString() => r'addLinkControllerProvider';
}

/// State of the Add link sheet (06): validation, live preview, collection.

abstract class _$AddLinkController extends $Notifier<AddLinkState> {
  late final _$args = ref.$arg as int?;
  int? get initialCollectionId => _$args;

  AddLinkState build(int? initialCollectionId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AddLinkState, AddLinkState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AddLinkState, AddLinkState>,
              AddLinkState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
