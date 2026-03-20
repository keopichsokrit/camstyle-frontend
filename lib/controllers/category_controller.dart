import 'dart:convert';
import '../core/constrains/api_constants.dart';
import '../models/category_model.dart';

class CategoryController {
  static Future<List<CategoryModel>> getAllCategories() async {
    final response = await ApiConstants.get(ApiConstants.categories);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((item) => CategoryModel.fromJson(item)).toList();
    }
    throw Exception("Failed to load categories");
  }
}