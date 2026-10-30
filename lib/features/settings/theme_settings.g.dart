// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Light / dark / system, AMOLED and accent.
/// Kept in memory for now; saved with shared_preferences in M6.

@ProviderFor(ThemeSettings)
final themeSettingsProvider = ThemeSettingsProvider._();

/// Light / dark / system, AMOLED and accent.
/// Kept in memory for now; saved with shared_preferences in M6.
final class ThemeSettingsProvider
    extends $NotifierProvider<ThemeSettings, ThemeSettingsState> {
  /// Light / dark / system, AMOLED and accent.
  /// Kept in memory for now; saved with shared_preferences in M6.
  ThemeSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeSettingsHash();

  @$internal
  @override
  ThemeSettings create() => ThemeSettings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeSettingsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeSettingsState>(value),
    );
  }
}

String _$themeSettingsHash() => r'8946c29ed3bfc6b5c55b92ec758a8dfe7580b0f5';

/// Light / dark / system, AMOLED and accent.
/// Kept in memory for now; saved with shared_preferences in M6.

abstract class _$ThemeSettings extends $Notifier<ThemeSettingsState> {
  ThemeSettingsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ThemeSettingsState, ThemeSettingsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeSettingsState, ThemeSettingsState>,
              ThemeSettingsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
