import 'dart:convert';
import '../models/product_model.dart';
import '../core/constrains/api_constants.dart';

class WishlistController {
  // Fetch all items in user's wishlist
  static Future<List<ProductModel>> getWishlist() async {
    try {
      final response = await ApiConstants.get(ApiConstants.wishlist);
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => ProductModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Toggle wishlist status
  static Future<bool> toggleWishlist(String productId) async {
    try {
      // Your backend uses POST /api/products/wishlist/:id
      final response = await ApiConstants.post(ApiConstants.toggleWishlist(productId), {});
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['isWishlisted'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}