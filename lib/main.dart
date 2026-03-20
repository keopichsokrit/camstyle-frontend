// lib/main.dart
import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart';

void main() {
  runApp(const CamStyleApp());
}

class CamStyleApp extends StatelessWidget {
  const CamStyleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CamStyle',
      debugShowCheckedModeBanner: false,
      // Use the constant from your AppRoutes file
      initialRoute: AppRoutes.startUp, 
      // This is the magic line that connects to your generateRoute logic
      onGenerateRoute: AppRoutes.generateRoute, 
    );
  }
}