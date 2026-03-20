
import 'package:flutter/material.dart';
import '../core/constrains/api_constants.dart';

class AdminController {
  // --- PRODUCT ACTIONS ---
  
  static Future<void> createProduct({
    required BuildContext context,
    required Map<String, String> fields,
    required String? imagePath,
  }) async {
    final response = await ApiConstants.multipartRequest(
      url: ApiConstants.products,
      method: 'POST',
      fields: fields,
      filePath: imagePath,
      fileKey: 'images', // Matches your backend req.files
    );

    if (response.statusCode == 201) {
      _notify(context, "Product Added Successfully");
    } else {
      _notify(context, "Failed to add product", isError: true);
    }
  }

  static Future<void> updateProduct(BuildContext context, String id, Map<String, dynamic> data) async {
    final response = await ApiConstants.put("${ApiConstants.products}/$id", data);
    if (response.statusCode == 200) {
      _notify(context, "Product Updated");
    }
  }

  static Future<void> deleteProduct(BuildContext context, String id) async {
    final response = await ApiConstants.delete("${ApiConstants.products}/$id");
    if (response.statusCode == 200) {
      _notify(context, "Product Deleted");
    }
  }

  // --- CATEGORY ACTIONS ---

  static Future<void> createCategory(BuildContext context, String name, String? imagePath) async {
    final response = await ApiConstants.multipartRequest(
      url: ApiConstants.categories,
      method: 'POST',
      fields: {'name': name},
      filePath: imagePath,
      fileKey: 'image', // Matches categoryController.js req.file
    );

    if (response.statusCode == 201) {
      _notify(context, "Category Created");
    }
  }

  static void _notify(BuildContext context, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: isError ? Colors.red : Colors.green),
    );
  }
}