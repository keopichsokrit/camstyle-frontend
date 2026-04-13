import 'dart:convert';
import '../models/size_model.dart';
import '../core/constrains/api_constants.dart';

class SizeController {
  static Future<List<SizeModel>> getAllSizes() async {
    try {
      final response = await ApiConstants.get(ApiConstants.sizes);
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => SizeModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}