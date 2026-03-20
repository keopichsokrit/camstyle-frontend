import 'dart:convert';
import '../models/product_model.dart';
import '../core/constrains/api_constants.dart';

class ProductController {
  static Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await ApiConstants.get(ApiConstants.products);
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => ProductModel.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      rethrow;
    }
  }
}