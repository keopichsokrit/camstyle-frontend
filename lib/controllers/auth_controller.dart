import 'dart:convert';
import 'package:camstyle_frontend/models/login_log_model.dart';
import 'package:flutter/material.dart';
import '../core/constrains/api_constants.dart';
import '../core/utils/storage_helper.dart';
import '../core/routes/app_routes.dart';

class AuthController {
  // --- LOGIN LOGIC ---
  static Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final response = await ApiConstants.post(ApiConstants.login, {
        "email": email,
        "password": password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Save token to storage for future API calls
        await StorageHelper.saveToken(data['token']);
            
        await StorageHelper.saveRole(data['role']);
        await StorageHelper.saveName(data['name']);
        
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
    String password,
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

  // --- FORGOT PASSWORD STEP 1 ---
  static Future<bool> sendOTP(BuildContext context, String email) async {
    try {
      final response = await ApiConstants.post(ApiConstants.forgotPassword, {
        "email": email,
      });
      if (response.statusCode == 200) {
        return true; // Success
      } else {
        final error = jsonDecode(response.body);
        _showError(context, error['message'] ?? "Error sending OTP");
        return false;
      }
    } catch (e) {
      _showError(context, "Connection Error");
      return false;
    }
  }

  // --- FORGOT PASSWORD STEP 2 ---
  static Future<void> resetPassword(
    BuildContext context,
    String email,
    String otp,
    String newPassword,
  ) async {
    try {
      final response = await ApiConstants.post(ApiConstants.resetPassword, {
        "email": email,
        "otp": otp,
        "newPassword": newPassword,
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password Reset Successful!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        final error = jsonDecode(response.body);
        _showError(context, error['message'] ?? "Invalid OTP or Expired");
      }
    } catch (e) {
      _showError(context, "Connection Error");
    }
  }
  static Future<List<LoginLogModel>> getLoginLogs() async {
  try {
    final response = await ApiConstants.get("${ApiConstants.baseUrl}/auth/logs");
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((log) => LoginLogModel.fromJson(log)).toList();
    }
    return [];
  } catch (e) {
    print("Error fetching logs: $e");
    return [];
  }
}
}
