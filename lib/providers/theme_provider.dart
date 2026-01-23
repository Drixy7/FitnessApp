import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppStyle { blue, pink }

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  AppStyle _appStyle = AppStyle.blue;

  ThemeMode get themeMode => _themeMode;
  AppStyle get appStyle => _appStyle;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadFromPrefs();
  }

  void toggleThemeMode() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
    _saveToPrefs();
  }

  void setAppStyle(AppStyle style) {
    _appStyle = style;
    notifyListeners();
    _saveToPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isPink = prefs.getBool('isPink') ?? false;
    final isDark = prefs.getBool('isDark') ?? false;

    _appStyle = isPink ? AppStyle.pink : AppStyle.blue;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPink', _appStyle == AppStyle.pink);
    await prefs.setBool('isDark', _themeMode == ThemeMode.dark);
  }
}
