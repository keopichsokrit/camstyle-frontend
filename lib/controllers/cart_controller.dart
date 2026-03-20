import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/constrains/api_constants.dart';
import '../models/cart_model.dart';
import '../core/routes/app_routes.dart';

class CartController {
  // GET: Fetch the cart from Backend
  static Future<CartModel?> getCart() async {
    try {
      final response = await ApiConstants.get(ApiConstants.cart);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['items'] == null || (data['items'] as List).isEmpty) return null;
        return CartModel.fromJson(data);
      }
    } catch (e) {
      debugPrint("Error fetching cart: $e");
    }
    return null;
  }

  // POST: Add to cart (Triggers stock reduction in backend)
  static Future<void> addToCart({
    required BuildContext context,
    required String productId,
    required int quantity,
  }) async {
    try {
      final response = await ApiConstants.post(ApiConstants.cart, {
        "productId": productId,
        "quantity": quantity,
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        _showSnackBar(context, "Added to cart!");
      } else {
        final error = jsonDecode(response.body);
        _showSnackBar(context, error['message'] ?? "Error", isError: true);
      }
    } catch (e) {
      _showSnackBar(context, "Connection failed", isError: true);
    }
  }

  // DELETE: Clear cart (Triggers stock restoration in backend)
  static Future<void> clearCart(BuildContext context, VoidCallback onSuccess) async {
    try {
      final response = await ApiConstants.delete(ApiConstants.cart);
      if (response.statusCode == 200) {
        onSuccess(); // Refresh the UI
        _showSnackBar(context, "Cart cleared & stock restored");
      }
    } catch (e) {
      _showSnackBar(context, "Clear failed", isError: true);
    }
  }

  static void payNow(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.payment);
  }

  static void _showSnackBar(BuildContext context, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: isError ? Colors.red : Colors.green),
    );
  }
}