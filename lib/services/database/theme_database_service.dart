import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeDatabaseService {
  static const String _boxName = 'settings';
  static const String _themeKey = 'themeMode';

  final Box _box;

  // Expects the pre-opened settings box injected into it
  ThemeDatabaseService(this._box);

  /// Retrieves the stored theme mode string and parses it into a ThemeMode object.
  ThemeMode getThemeMode() {
    final String? saved = _box.get(_themeKey) as String?;
    return _stringToThemeMode(saved);
  }

  /// Saves the active ThemeMode back into Hive storage using its standard name.
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _box.put(_themeKey, mode.name);
  }

  /// Internal conversion mapper helper.
  ThemeMode _stringToThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
