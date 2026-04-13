// lib/main.dart
import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const CamStyleApp());
}

class CamStyleApp extends StatelessWidget {
  const CamStyleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
    return MaterialApp(
      title: 'CamStyle',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: currentMode, // Start with system theme, but can be toggled in profile
      // Use the constant from your AppRoutes file
      initialRoute: AppRoutes.startUp, 
      // This is the magic line that connects to your generateRoute logic
      onGenerateRoute: AppRoutes.generateRoute, 
    );
      },
    );
  }
}