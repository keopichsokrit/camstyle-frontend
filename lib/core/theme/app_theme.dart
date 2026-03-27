import 'package:flutter/material.dart';

ColorScheme cs = ColorScheme.fromSeed(seedColor: Colors.cyanAccent);
ColorScheme sc = ColorScheme.fromSeed(seedColor: Colors.blue);
final ThemeData lighttheme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: cs.primary,
  ),
  scaffoldBackgroundColor: cs.secondary,
  drawerTheme: DrawerThemeData(
    backgroundColor: cs.secondary,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: cs.tertiary,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: cs.primary,
  ),
);
final ThemeData darktheme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: sc.primary,
  ),
  scaffoldBackgroundColor: cs.secondary,
  drawerTheme: DrawerThemeData(
    backgroundColor: sc.secondary,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: sc.tertiary,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: sc.primary,
  ),
);