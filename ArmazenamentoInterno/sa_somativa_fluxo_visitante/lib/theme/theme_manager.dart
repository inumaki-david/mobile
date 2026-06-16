import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Inicia com o Dark Mode por padrão

  ThemeMode get themeMode => _themeMode;

  // Carrega a preferência do banco local ao iniciar o app
  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool('isDarkMode') ?? true; // Padrão é true (Dark)
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Avisa o app para redesenhar a tela
  }

  // Alterna o tema e salva a nova preferência
  void toggleTheme() async {
    bool isCurrentlyDark = _themeMode == ThemeMode.dark;
    _themeMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', !isCurrentlyDark);
  }
}