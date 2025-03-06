import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme() {

    _themeMode=_themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    print(_themeMode);
    _saveTheme();
    notifyListeners();
  }

  void _saveTheme() async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool("isDarkMode", _themeMode == ThemeMode.dark);
  }

  void _loadTheme() async {
    final pref = await SharedPreferences.getInstance();
    bool?isDarkMode = pref.getBool("isDarkMode");
    _themeMode = isDarkMode == true ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}