import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/constrains/api_constants.dart';
import '../core/utils/storage_helper.dart';
import '../core/routes/app_routes.dart';

class AuthController {
  // --- LOGIN LOGIC ---
  static Future<void> login(BuildContext context, String email, String password) async {
    try {
      final response = await ApiConstants.post(ApiConstants.login, {
        "email": email,
        "password": password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Save token to storage for future API calls
        await StorageHelper.saveToken(data['token']);
        
        // Check role and navigate
        if (data['role'] == 'admin') {
          Navigator.pushReplacementNamed(context, AppRoutes.adminHome);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.userHome);
        }
      } else {
        final error = jsonDecode(response.body);
        _showError(context, error['message'] ?? "Login Failed");
      }
    } catch (e) {
      _showError(context, "Connection Error: Check your backend.");
    }
  }

  // --- REGISTER LOGIC ---
  static Future<void> register(
    BuildContext context, 
    String name, 
    String email, 
    String password
  ) async {
    // 1. Simple validation before even hitting the API
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError(context, "Please fill in all fields");
      return;
    }

    try {
      final response = await ApiConstants.post(ApiConstants.register, {
        "name": name,
        "email": email,
        "password": password,
      });

      // Check if the widget is still in the tree before using context
      if (!context.mounted) return;

      if (response.statusCode == 201) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account created! Please login."),
            backgroundColor: Colors.green,
          ),
        );
        // Move to Login Screen
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        // Error from Backend (e.g., User already exists)
        final error = jsonDecode(response.body);
        _showError(context, error['message'] ?? "Registration Failed");
      }
    } catch (e) {
      if (!context.mounted) return;
      debugPrint("Register Error: $e");
      _showError(context, "Connection Error: Is the server running?");
    }
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
