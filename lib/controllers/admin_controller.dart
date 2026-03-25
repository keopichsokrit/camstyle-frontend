import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/constrains/api_constants.dart';
import '../core/utils/storage_helper.dart'; // Needed to get the token manually
import 'package:image_picker/image_picker.dart'; // Add this

class AdminController {
  // --- PRODUCT ACTIONS ---

  static Future<bool> createProduct({
    required BuildContext context,
    required Map<String, String> fields,
    required List<XFile> imageFiles, // Change parameter from String paths to XFile
  }) async {
    try {
      final url = Uri.parse(ApiConstants.products);
      var request = http.MultipartRequest('POST', url);

      // Since _getHeaders is private, we manually add the token here
      // just like you did in your multipartRequest method in ApiConstants
      final token = await StorageHelper.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add Text Fields
      request.fields.addAll(fields);

      // Add Multiple Files (Backend: upload.array('images', 5))
      // for (String path in imagePaths) {
      //   request.files.add(await http.MultipartFile.fromPath('images', path));
      // }
      // FIX FOR WEB: Read bytes from XFile instead of using fromPath
      for (XFile file in imageFiles) {
        final bytes = await file.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'images', 
            bytes,
            filename: file.name, // Important for backend
          ),
        );
      }

      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 201) {
        _notify(context, "Product Added Successfully");
        return true;
      } else {
        _notify(context, "Failed to add product", isError: true);
        return false;
      }
    } catch (e) {
      _notify(context, "Error: $e", isError: true);
      return false;
    }
  }

  // --- CATEGORY ACTIONS ---

  static Future<bool> createCategory({
    required BuildContext context,
    required String name,
    required String description,
    required XFile? imageFile, // Changed from String? imagePath to XFile? imageFile
  }) async {
    try {
      final url = Uri.parse(ApiConstants.categories);
      var request = http.MultipartRequest('POST', url);

      // Add Authorization Token
      final token = await StorageHelper.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add Text Fields
      request.fields.addAll({
        'name': name,
        'description': description,
      });

      // Add Image as bytes (Cross-platform fix for Web/Android)
      if (imageFile != null) {
        final bytes = await imageFile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'image', // Matches backend: upload.single('image')
            bytes,
            filename: imageFile.name,
          ),
        );
      }

      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 201) {
        _notify(context, "Category Created Successfully");
        return true;
      } else {
        _notify(context, "Failed to create category", isError: true);
        return false;
      }
    } catch (e) {
      _notify(context, "Error: $e", isError: true);
      return false;
    }
  }
  
  // --- NEW: UPDATE CATEGORY ACTION ---
  static Future<bool> updateCategory({
    required BuildContext context,
    required String id,
    required String name,
    required String description,
    required XFile? imageFile,
  }) async {
    try {
      final url = Uri.parse("${ApiConstants.categories}/$id");
      var request = http.MultipartRequest('PUT', url);

      final token = await StorageHelper.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      
      // Ensure the content type is explicitly handled for form-data
      request.headers['Accept'] = 'application/json';

      // Use individual assignments instead of .addAll for clarity
      request.fields['name'] = name;
      request.fields['description'] = description;

      if (imageFile != null) {
        final bytes = await imageFile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: imageFile.name,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Log the response body to see if the server actually sent back the updated desc
        debugPrint("Server Response: ${response.body}");
        _notify(context, "Category Updated Successfully");
        return true;
      } else {
        debugPrint("Error Body: ${response.body}");
        _notify(context, "Update Failed: ${response.statusCode}", isError: true);
        return false;
      }
    } catch (e) {
      _notify(context, "Error: $e", isError: true);
      return false;
    }
  }
  
// --- UPDATE PRODUCT (Multipart Pattern) ---
  // --- UPDATED: UPDATE PRODUCT ---
  // Matches your backend: PUT /api/products/:id (JSON) + PUT /api/products/:id/images (Multipart)
  static Future<bool> updateProduct({
    required BuildContext context,
    required String id,
    required Map<String, dynamic> fields,
    required List<XFile> imageFiles,
  }) async {
    try {
      final token = await StorageHelper.getToken();
      
      // 1. Update Text Fields (Name, Price, Qty, Desc)
      // Your backend does NOT use multer here, so we must send JSON
      final textUrl = Uri.parse("${ApiConstants.products}/$id");
      final textResponse = await http.put(
        textUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(fields), // Converts Map to JSON String
      );

      if (textResponse.statusCode != 200) {
        debugPrint("Text Update Error: ${textResponse.body}");
        _notify(context, "Failed to update product details", isError: true);
        return false;
      }

      // 2. Update Images ONLY if new ones were picked
      // Your backend DOES use multer here (upload.array)
      if (imageFiles.isNotEmpty) {
        final imgUrl = Uri.parse("${ApiConstants.products}/$id/images");
        var imgRequest = http.MultipartRequest('PUT', imgUrl);
        imgRequest.headers['Authorization'] = 'Bearer $token';

        for (XFile file in imageFiles) {
          final bytes = await file.readAsBytes();
          imgRequest.files.add(
            http.MultipartFile.fromBytes(
              'images', // Must match backend: upload.array('images')
              bytes,
              filename: file.name,
            ),
          );
        }

        final imgStream = await imgRequest.send();
        final imgResponse = await http.Response.fromStream(imgStream);

        if (imgResponse.statusCode != 200) {
          debugPrint("Image Update Error: ${imgResponse.body}");
          _notify(context, "Details updated, but image upload failed", isError: true);
          return false;
        }
      }

      _notify(context, "Product Updated Successfully");
      return true;
    } catch (e) {
      debugPrint("Update Exception: $e");
      _notify(context, "Error: $e", isError: true);
      return false;
    }
  }

  // --- HELPER FOR SNACKBARS ---
  // This is likely where your error was. It MUST be static.
  static void _notify(
    BuildContext context,
    String msg, {
    bool isError = false,
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Keep your existing createProduct and createCategory below...
}
