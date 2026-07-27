import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeDatabaseService {
  static const String _themeKey = 'themeMode';

  final Box _box;

  ThemeDatabaseService(this._box);

  // get theme mode
  ThemeMode getThemeMode() {
    final String? saved = _box.get(_themeKey) as String?;
    return _stringToThemeMode(saved);
  }

  // save theme mode
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _box.put(_themeKey, mode.name);
  }

  //toggle theme helper.
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
