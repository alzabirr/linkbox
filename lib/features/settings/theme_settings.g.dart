// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Light / dark / system, AMOLED, dynamic color and accent, saved in
/// settings (`theme_mode`, `amoled`, `dynamic_color`, `accent`).

@ProviderFor(ThemeSettings)
final themeSettingsProvider = ThemeSettingsProvider._();

/// Light / dark / system, AMOLED, dynamic color and accent, saved in
/// settings (`theme_mode`, `amoled`, `dynamic_color`, `accent`).
final class ThemeSettingsProvider
    extends $NotifierProvider<ThemeSettings, ThemeSettingsState> {
  /// Light / dark / system, AMOLED, dynamic color and accent, saved in
  /// settings (`theme_mode`, `amoled`, `dynamic_color`, `accent`).
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

String _$themeSettingsHash() => r'7f36cb7be167c8ade117bf7159a8a997f8924fdf';

/// Light / dark / system, AMOLED, dynamic color and accent, saved in
/// settings (`theme_mode`, `amoled`, `dynamic_color`, `accent`).

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

@ProviderFor(TapActionSetting)
final tapActionSettingProvider = TapActionSettingProvider._();

final class TapActionSettingProvider
    extends $NotifierProvider<TapActionSetting, TapAction> {
  TapActionSettingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tapActionSettingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tapActionSettingHash();

  @$internal
  @override
  TapActionSetting create() => TapActionSetting();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TapAction value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TapAction>(value),
    );
  }
}

String _$tapActionSettingHash() => r'f1b2d552bc778f7d35a019043c87f7f089a2e75f';

abstract class _$TapActionSetting extends $Notifier<TapAction> {
  TapAction build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TapAction, TapAction>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TapAction, TapAction>,
              TapAction,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The intro (16–18) was finished: `onboarding_done`.

@ProviderFor(OnboardingDone)
final onboardingDoneProvider = OnboardingDoneProvider._();

/// The intro (16–18) was finished: `onboarding_done`.
final class OnboardingDoneProvider
    extends $NotifierProvider<OnboardingDone, bool> {
  /// The intro (16–18) was finished: `onboarding_done`.
  OnboardingDoneProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingDoneProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingDoneHash();

  @$internal
  @override
  OnboardingDone create() => OnboardingDone();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$onboardingDoneHash() => r'7e4f45c310b0f183844983f477063378ff2671f7';

/// The intro (16–18) was finished: `onboarding_done`.

abstract class _$OnboardingDone extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
