import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/storage_helper.dart';
import 'package:image_picker/image_picker.dart';

class ApiConstants {
  // 1. Base Configuration
  // Use '10.0.2.2' for Android Emulator to access localhost, 
  // or your machine's local IP for physical devices.
  // static const String baseUrl = "http://10.0.2.2:5000/api";
  static const String baseUrl = "http://localhost:5000/api";

  // 2. Endpoints
  // Auth
  static const String login = "$baseUrl/auth/login";
  static const String register = "$baseUrl/auth/register";
  static const String userProfile = "$baseUrl/auth/profile";

  // Products & Categories
  static const String products = "$baseUrl/products";
  static const String categories = "$baseUrl/categories";

  // Cart
  static const String cart = "$baseUrl/cart";

  // Payment
  static const String checkout = "$baseUrl/payment/checkout";
  static const String verifyPayment = "$baseUrl/payment/verify";

  // Profile Update
  static const String updateProfile = "$baseUrl/profile/update";

  // 3. Centralized HTTP Logic (The Engine)
  // This allows controllers to call API without writing 'Header' logic every time
  static Future<Map<String, String>> _getHeaders() async {
    String? token = await StorageHelper.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // GET Request
  static Future<http.Response> get(String url) async {
    final headers = await _getHeaders();
    return await http.get(Uri.parse(url), headers: headers);
  }

  // POST Request
  static Future<http.Response> post(String url, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    return await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  // PUT Request
  static Future<http.Response> put(String url, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    return await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  // DELETE Request
  static Future<http.Response> delete(String url) async {
    final headers = await _getHeaders();
    return await http.delete(Uri.parse(url), headers: headers);
  }

  // Multipart/File Upload (For Products/Profile Images)
  static Future<http.StreamedResponse> multipartRequest({
    required String url,
    required String method,
    required Map<String, String> fields,
    XFile? imageFile, // Use XFile directly
    String fileKey = 'image',
  }) async {
    final token = await StorageHelper.getToken();
    var request = http.MultipartRequest(method, Uri.parse(url));
    
    request.headers.addAll({
      if (token != null) 'Authorization': 'Bearer $token',
    });

    request.fields.addAll(fields);

    // CROSS-PLATFORM FIX: Read bytes instead of using path
    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        fileKey,
        bytes,
        filename: imageFile.name,
      ));
    }

    return await request.send();
  }
}