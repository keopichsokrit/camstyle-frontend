import 'dart:convert';
import '../core/constrains/api_constants.dart';
import '../models/notification_model.dart';

class NotificationController {
  static Future<List<NotificationModel>> getNotifications() async {
    try {
      // Points to: http://localhost:5000/api/notifications
      final response = await ApiConstants.get("${ApiConstants.baseUrl}/notifications");

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => NotificationModel.fromJson(item)).toList();
      } else {
        print("Backend Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Connection Error: $e");
      return [];
    }
  }
}