import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;
  void setMode(ThemeMode m){ _mode = m; notifyListeners(); }

  static const Color asuNavy = Color(0xFF214D8B);
  static const Color asuGold = Color(0xFFF2C75B);

  ThemeData get light => ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: asuNavy,
      onPrimary: Colors.white,
      secondary: asuGold,
      onSecondary: Colors.black,
      error: const Color(0xFFB00020),
      onError: Colors.white,
      background: const Color(0xFFF7F8FA),
      onBackground: const Color(0xFF101418),
      surface: Colors.white,
      onSurface: const Color(0xFF0F1113),
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(centerTitle: true),
    fontFamily: 'Roboto',
  );

  ThemeData get dark => ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: asuNavy,
      onPrimary: Colors.white,
      secondary: asuGold,
      onSecondary: Colors.black,
      error: const Color(0xFFCF6679),
      onError: Colors.black,
      background: const Color(0xFF0D1117),
      onBackground: const Color(0xFFE6E6E6),
      surface: const Color(0xFF161B22),
      onSurface: const Color(0xFFE6E6E6),
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(centerTitle: true),
    fontFamily: 'Roboto',
  );
}
