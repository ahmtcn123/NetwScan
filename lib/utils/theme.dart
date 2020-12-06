import 'package:flutter/material.dart';

int theme = 0;
class AppTheme with ChangeNotifier {
  ThemeMode currentTheme() {
    return theme == 0 ? ThemeMode.system : theme == 1 ? ThemeMode.dark : ThemeMode.light;
  }

  int currentThemeID() {
    return theme;
  }

  void setTheme(int themeID) {
    theme = themeID;
    notifyListeners();
  }

  void switchTheme() {
    theme = theme == 0 ? 1 : theme == 1 ? 2 : 0;
    notifyListeners();
  }
}
