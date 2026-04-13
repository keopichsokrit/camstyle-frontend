import 'dart:convert';
import '../models/banner_model.dart';
import '../core/constrains/api_constants.dart';

class BannerController {
  static Future<List<BannerModel>> getActiveBanners() async {
    try {
      final response = await ApiConstants.get(ApiConstants.banners);
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => BannerModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}