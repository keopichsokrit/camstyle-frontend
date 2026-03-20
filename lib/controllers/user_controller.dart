import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/constrains/api_constants.dart';

class UserController {
  // Update User Profile (Name and/or Password)
  static Future<bool> updateProfile({
    required BuildContext context,
    required String name,
    String? password,
  }) async {
    try {
      // Build the request body
      Map<String, dynamic> body = {"name": name};
      if (password != null && password.isNotEmpty) {
        body["password"] = password;
      }

      final response = await ApiConstants.put("/user/profile", body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
        return true;
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error['message'] ?? "Update failed")),
        );
        return false;
      }
    } catch (e) {
      debugPrint("Update Error: $e");
      return false;
    }
  }
}