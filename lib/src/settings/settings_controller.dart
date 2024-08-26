import 'package:flutter/material.dart';

class SettingsController with ChangeNotifier {
  SettingsController();

  Future<ThemeMode> themeModeS() async => ThemeMode.system;

  Future<void> updateThemeModeS(ThemeMode theme) async {}
  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadSettings() async {
    _themeMode = await themeModeS();

    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;

    notifyListeners();

    await updateThemeModeS(newThemeMode);
  }
}
