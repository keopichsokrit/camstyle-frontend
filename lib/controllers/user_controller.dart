import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../core/constrains/api_constants.dart';
import '../models/user_model.dart';

class UserController {
  static Future<UserModel?> getProfile() async {
    try {
      final response = await ApiConstants.get(ApiConstants.userProfile);
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateProfile({
    required BuildContext context,
    String? name, 
    String? oldPassword,
    String? newPassword,
    XFile? imageFile,
    // --- NEW ARGUMENTS ---
    String? birthdate,
    String? home,
    String? city,
    String? homeTown,
    String? phoneNumber,
  }) async {
    try {
      Map<String, String> fields = {};
      
      // Only add to the request if the data actually exists
      if (name != null && name.isNotEmpty) fields["name"] = name;
      if (oldPassword != null && oldPassword.isNotEmpty) fields["oldPassword"] = oldPassword;
      if (newPassword != null && newPassword.isNotEmpty) fields["newPassword"] = newPassword;
      // Add new fields to the multipart request
      if (birthdate != null) fields["birthdate"] = birthdate;
      if (home != null) fields["home"] = home;
      if (city != null) fields["city"] = city;
      if (homeTown != null) fields["homeTown"] = homeTown;
      if (phoneNumber != null) fields["phoneNumber"] = phoneNumber;
      final streamedResponse = await ApiConstants.multipartRequest(
        url: ApiConstants.updateProfile,
        method: 'PUT',
        fields: fields,
        imageFile: imageFile, // Pass XFile directly
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return true;
      } else {
        final error = jsonDecode(response.body);
        _showError(context, error['message'] ?? "Update failed");
        return false;
      }
    } catch (e) {
      _showError(context, "Network Error: $e");
      return false;
    }
  }

  static void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }
}