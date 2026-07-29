import 'package:flutter/material.dart';
import 'package:product_catalogue/services/database/theme_database_service.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeDatabaseService _dbService;
  late ThemeMode _themeMode;

  ThemeProvider(this._dbService) {
    _themeMode = _dbService.getThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return; 
    
    _themeMode = mode;
    notifyListeners();
    
    await _dbService.saveThemeMode(mode);
  }
}
