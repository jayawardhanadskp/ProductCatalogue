import 'package:flutter/material.dart';
import 'package:product_catalogue/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _theme = AppTheme.light;

  ThemeData get theme => _theme;

  void toggleTheme() {
    _theme = _theme == AppTheme.light ? AppTheme.dark : AppTheme.light;
    notifyListeners();
  }
}