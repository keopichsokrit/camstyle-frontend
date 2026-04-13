import 'dart:convert';
import '../models/color_model.dart';
import '../core/constrains/api_constants.dart';

class ColorController {
  static Future<List<ColorModel>> getAllColors() async {
    try {
      final response = await ApiConstants.get(ApiConstants.colors);
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => ColorModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}