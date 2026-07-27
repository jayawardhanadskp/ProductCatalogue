import 'package:flutter/material.dart';
import 'package:product_catalogue/services/database/theme_database_service.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeDatabaseService _dbService;
  late ThemeMode _themeMode;

  ThemeProvider(this._dbService) {
    // Read the stored config through our layer service on startup
    _themeMode = _dbService.getThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  /// Changes the application's global theme layout and updates the disk storage concurrently.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return; // Prevent useless rebuilds if the mode is identical
    
    _themeMode = mode;
    notifyListeners();
    
    await _dbService.saveThemeMode(mode);
  }
}
