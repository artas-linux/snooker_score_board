import 'package:flutter/material.dart';
import 'package:snooker_score_board/ui/themes/app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: TokyoNightColors.cyan,
    colorScheme: const ColorScheme.light(
      primary: TokyoNightColors.cyan,
      onPrimary: TokyoNightColors.darkBlue,
      secondary: TokyoNightColors.green,
      onSecondary: TokyoNightColors.darkBlue,
      surface: TokyoNightColors.white,
      onSurface: TokyoNightColors.darkBlue,
      error: TokyoNightColors.red,
      onError: TokyoNightColors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: TokyoNightColors.cyan,
      foregroundColor: TokyoNightColors.darkBlue,
    ),
    cardTheme: CardThemeData(
      color: TokyoNightColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: TokyoNightColors.cyan,
        foregroundColor: TokyoNightColors.darkBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: TokyoNightColors.cyan, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      labelStyle: TextStyle(color: TokyoNightColors.lightBlue),
    ),
    // Add more theme properties as needed
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: CatppuccinColors.blue,
    colorScheme: const ColorScheme.dark(
      primary: CatppuccinColors.blue,
      onPrimary: CatppuccinColors.crust,
      secondary: CatppuccinColors.green,
      onSecondary: CatppuccinColors.crust,
      surface: CatppuccinColors.mantle,
      onSurface: CatppuccinColors.text,
      error: CatppuccinColors.red,
      onError: CatppuccinColors.crust,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: CatppuccinColors.mantle,
      foregroundColor: CatppuccinColors.text,
    ),
    cardTheme: CardThemeData(
      color: CatppuccinColors.surface0,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: CatppuccinColors.blue,
        foregroundColor: CatppuccinColors.crust,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: CatppuccinColors.blue, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      labelStyle: TextStyle(color: CatppuccinColors.subtext1),
    ),
    // Add more theme properties as needed
  );
}