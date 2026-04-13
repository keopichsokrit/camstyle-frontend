import 'package:flutter/material.dart';

// Brand Palette constants
const Color luxuryGold = Color(0xFFC5A358);
const Color midnightBlack = Color(0xFF0A0A0A);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: luxuryGold,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: midnightBlack,
    elevation: 0,
    iconTheme: IconThemeData(color: midnightBlack),
  ),
  // Gold buttons for Light Mode
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: luxuryGold,
      foregroundColor: Colors.white,
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: midnightBlack),
    bodyMedium: TextStyle(color: midnightBlack),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: midnightBlack,
  primaryColor: luxuryGold,
  appBarTheme: const AppBarTheme(
    backgroundColor: midnightBlack,
    foregroundColor: luxuryGold,
    elevation: 0,
    iconTheme: IconThemeData(color: luxuryGold),
  ),
  // Gold buttons for Dark Mode
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: luxuryGold,
      foregroundColor: midnightBlack,
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
  ),
);

class AppTheme {
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  static void toggleTheme() {
    themeNotifier.value = themeNotifier.value == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
  }
}