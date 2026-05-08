import 'package:flutter/material.dart';

/// ============================================================================
/// THEME PROVIDER - Global State quản lý Dark Mode + Accent Color
/// Sử dụng InheritedWidget + ValueNotifier cho performance tối ưu.
/// ============================================================================

/// Accent color preset definitions
class AccentColorPreset {
  final String name;
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color primarySurface;

  const AccentColorPreset({
    required this.name,
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.primarySurface,
  });
}

/// All available accent color presets
const List<AccentColorPreset> accentPresets = [
  AccentColorPreset(
    name: 'Corporate Blue',
    primary: Color(0xFF0F4C81),
    primaryLight: Color(0xFF1A73E8),
    primaryDark: Color(0xFF0A3560),
    primarySurface: Color(0xFFE8F0FE),
  ),
  AccentColorPreset(
    name: 'Emerald',
    primary: Color(0xFF059669),
    primaryLight: Color(0xFF10B981),
    primaryDark: Color(0xFF047857),
    primarySurface: Color(0xFFD1FAE5),
  ),
  AccentColorPreset(
    name: 'Royal Purple',
    primary: Color(0xFF7C3AED),
    primaryLight: Color(0xFF8B5CF6),
    primaryDark: Color(0xFF6D28D9),
    primarySurface: Color(0xFFEDE9FE),
  ),
  AccentColorPreset(
    name: 'Sunset',
    primary: Color(0xFFEA580C),
    primaryLight: Color(0xFFF97316),
    primaryDark: Color(0xFFC2410C),
    primarySurface: Color(0xFFFFF7ED),
  ),
  AccentColorPreset(
    name: 'Rose',
    primary: Color(0xFFE11D48),
    primaryLight: Color(0xFFF43F5E),
    primaryDark: Color(0xFFBE123C),
    primarySurface: Color(0xFFFFF1F2),
  ),
];

/// Theme state holder
class ThemeState {
  final ThemeMode themeMode;
  final int accentIndex;

  const ThemeState({
    this.themeMode = ThemeMode.light,
    this.accentIndex = 0,
  });

  AccentColorPreset get accent => accentPresets[accentIndex];

  ThemeState copyWith({ThemeMode? themeMode, int? accentIndex}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      accentIndex: accentIndex ?? this.accentIndex,
    );
  }
}

/// Global theme notifier
class ThemeNotifier extends ValueNotifier<ThemeState> {
  ThemeNotifier() : super(const ThemeState());

  void setThemeMode(ThemeMode mode) {
    value = value.copyWith(themeMode: mode);
  }

  void setAccentColor(int index) {
    if (index >= 0 && index < accentPresets.length) {
      value = value.copyWith(accentIndex: index);
    }
  }
}

/// InheritedWidget for easy access
class ThemeProvider extends InheritedNotifier<ThemeNotifier> {
  const ThemeProvider({
    super.key,
    required ThemeNotifier notifier,
    required super.child,
  }) : super(notifier: notifier);

  static ThemeNotifier of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
    return provider!.notifier!;
  }

  static ThemeState stateOf(BuildContext context) {
    return of(context).value;
  }
}
