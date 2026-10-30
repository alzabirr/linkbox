// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(shareChannel)
final shareChannelProvider = ShareChannelProvider._();

final class ShareChannelProvider
    extends $FunctionalProvider<ShareChannel, ShareChannel, ShareChannel>
    with $Provider<ShareChannel> {
  ShareChannelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shareChannelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shareChannelHash();

  @$internal
  @override
  $ProviderElement<ShareChannel> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ShareChannel create(Ref ref) {
    return shareChannel(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShareChannel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShareChannel>(value),
    );
  }
}

String _$shareChannelHash() => r'3869aac0915ecea2707237789b82ad5de2178ebc';

/// Share flow (BUILD_SPEC 4): extract → duplicate check → save → preview.

@ProviderFor(ShareController)
final shareControllerProvider = ShareControllerProvider._();

/// Share flow (BUILD_SPEC 4): extract → duplicate check → save → preview.
final class ShareControllerProvider
    extends $NotifierProvider<ShareController, ShareState> {
  /// Share flow (BUILD_SPEC 4): extract → duplicate check → save → preview.
  ShareControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shareControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shareControllerHash();

  @$internal
  @override
  ShareController create() => ShareController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShareState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShareState>(value),
    );
  }
}

String _$shareControllerHash() => r'0b48d4256bc2177107b0eb4ccf6317565ba55ae3';

/// Share flow (BUILD_SPEC 4): extract → duplicate check → save → preview.

abstract class _$ShareController extends $Notifier<ShareState> {
  ShareState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ShareState, ShareState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ShareState, ShareState>,
              ShareState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
