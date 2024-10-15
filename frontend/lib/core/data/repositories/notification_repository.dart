import 'dart:convert';
import 'package:flutter_web_fe/core/services/api_service.dart';
import 'package:flutter_web_fe/core/data/models/notification_model.dart';

class NotificationService {
  final ApiClient apiClient;

  NotificationService(this.apiClient);

  Future<List<NotificationModel>> fetchNotifications() async {
    final response = await apiClient.get('/thongbao');
    if (response.statusCode == 200) {
      final utf8Response = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> data = jsonDecode(utf8Response);
      final List<dynamic> results = data['results'];

      return results.map((item) => NotificationModel.fromJson(item)).toList();
    } else {
      throw Exception('Không thể tải thông báo');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final response = await apiClient.get('notifications/$notificationId/read');

    if (response.statusCode != 200) {
      throw Exception('Không thể đánh dấu thông báo là đã đọc');
    }
  }
}
