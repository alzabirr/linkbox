import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/theme/tokens.dart';
import '../../core/providers.dart';

part 'theme_settings.g.dart';

@immutable
class ThemeSettingsState {
  const ThemeSettingsState({
    this.mode = ThemeMode.light,
    this.amoled = false,
    this.dynamicColor = false,
    this.accent = AppColors.primary,
  });

  final ThemeMode mode;

  /// Pure black dark mode (15, 30).
  final bool amoled;

  /// "Match my wallpaper": Android 12+ dynamic color as the accent.
  final bool dynamicColor;
  final Color accent;

  ThemeSettingsState copyWith({
    ThemeMode? mode,
    bool? amoled,
    bool? dynamicColor,
    Color? accent,
  }) =>
      ThemeSettingsState(
        mode: mode ?? this.mode,
        amoled: amoled ?? this.amoled,
        dynamicColor: dynamicColor ?? this.dynamicColor,
        accent: accent ?? this.accent,
      );
}

/// Light / dark / system, AMOLED, dynamic color and accent, saved in
/// settings (`theme_mode`, `amoled`, `dynamic_color`, `accent`).
@riverpod
class ThemeSettings extends _$ThemeSettings {
  @override
  ThemeSettingsState build() {
    final p = ref.watch(sharedPrefsProvider);
    final hex = p.getString('accent');
    return ThemeSettingsState(
      mode: ThemeMode.values.asNameMap()[p.getString('theme_mode')] ??
          ThemeMode.light,
      amoled: p.getBool('amoled') ?? false,
      dynamicColor: p.getBool('dynamic_color') ?? false,
      accent: hex == null ? AppColors.primary : parseHex(hex) ?? AppColors.primary,
    );
  }

  void setMode(ThemeMode mode) {
    state = state.copyWith(mode: mode);
    ref.read(sharedPrefsProvider).setString('theme_mode', mode.name);
  }

  void setAmoled(bool on) {
    state = state.copyWith(amoled: on);
    ref.read(sharedPrefsProvider).setBool('amoled', on);
  }

  void setDynamicColor(bool on) {
    state = state.copyWith(dynamicColor: on);
    ref.read(sharedPrefsProvider).setBool('dynamic_color', on);
  }

  void setAccent(Color color) {
    state = state.copyWith(accent: color, dynamicColor: false);
    final p = ref.read(sharedPrefsProvider);
    p.setString('accent', toHex(color));
    p.setBool('dynamic_color', false);
  }
}

/// "#FF8A3D" or "FF8A3D" → Color; null if it isn't a 6-digit hex code.
Color? parseHex(String input) {
  final s = input.trim().replaceFirst('#', '');
  if (!RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(s)) return null;
  return Color(int.parse(s, radix: 16) | 0xFF000000);
}

String toHex(Color c) =>
    '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

/// What tapping a link does (13): `tap_action`.
enum TapAction { quickLook, open, copy }

@riverpod
class TapActionSetting extends _$TapActionSetting {
  @override
  TapAction build() =>
      TapAction.values.asNameMap()[
          ref.watch(sharedPrefsProvider).getString('tap_action')] ??
      TapAction.quickLook;

  void set(TapAction a) {
    state = a;
    ref.read(sharedPrefsProvider).setString('tap_action', a.name);
  }
}

/// The intro (16–18) was finished: `onboarding_done`.
@riverpod
class OnboardingDone extends _$OnboardingDone {
  @override
  bool build() =>
      ref.watch(sharedPrefsProvider).getBool('onboarding_done') ?? false;

  void set(bool done) {
    state = done;
    ref.read(sharedPrefsProvider).setBool('onboarding_done', done);
  }
}
