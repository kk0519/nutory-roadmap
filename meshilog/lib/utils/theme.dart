import 'package:flutter/material.dart';

const _accent = Color(0xFF22C55E); // エメラルドグリーン
const _bg    = Color(0xFF0D1117);
const _card  = Color(0xFF161B22);
const _border = Color(0xFF30363D);

class AppTheme {
  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _bg,
    colorScheme: ColorScheme.dark(
      primary: _accent,
      surface: _card,
      outline: _border,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _card,
      indicatorColor: _accent.withOpacity(0.2),
    ),
    cardTheme: const CardTheme(color: _card),
    appBarTheme: const AppBarTheme(
      backgroundColor: _card,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );

  static const accent = _accent;
  static const background = _bg;
  static const card = _card;
  static const muted = Color(0xFF8B949E);
  static const orange = Color(0xFFF97316);
}
