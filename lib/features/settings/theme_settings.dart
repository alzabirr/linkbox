import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/theme/tokens.dart';

part 'theme_settings.g.dart';

@immutable
class ThemeSettingsState {
  const ThemeSettingsState({
    this.mode = ThemeMode.system,
    this.amoled = false,
    this.accent = AppColors.primary,
  });

  final ThemeMode mode;
  final bool amoled;
  final Color accent;

  ThemeSettingsState copyWith({ThemeMode? mode, bool? amoled, Color? accent}) =>
      ThemeSettingsState(
        mode: mode ?? this.mode,
        amoled: amoled ?? this.amoled,
        accent: accent ?? this.accent,
      );
}

/// Light / dark / system, AMOLED and accent.
/// Kept in memory for now; saved with shared_preferences in M6.
@riverpod
class ThemeSettings extends _$ThemeSettings {
  @override
  ThemeSettingsState build() => const ThemeSettingsState();

  void setMode(ThemeMode mode) => state = state.copyWith(mode: mode);
  void setAmoled(bool on) => state = state.copyWith(amoled: on);
  void setAccent(Color color) => state = state.copyWith(accent: color);
}
