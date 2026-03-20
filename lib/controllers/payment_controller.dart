import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/constrains/api_constants.dart';

class PaymentController {
  // Call POST /api/payment/checkout (Matches your Express route)
  static Future<Map<String, dynamic>?> generateKHQR() async {
    try {
      // Body is empty because backend gets the cart from req.user._id
      final response = await ApiConstants.post(ApiConstants.checkout, {}); 
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint("Server Error: ${response.body}");
      }
    } catch (e) {
      debugPrint("QR Generation Error: $e");
    }
    return null;
  }

  static Future<String> verifyStatus(String md5) async {
    try {
      final response = await ApiConstants.post(ApiConstants.verifyPayment, {"md5": md5});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status']; // 'success' or 'pending'
      }
    } catch (e) {
      debugPrint("Verification Error: $e");
    }
    return 'error';
  }
}