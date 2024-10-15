import 'package:flutter_web_fe/core/data/models/order_model.dart';
import 'package:flutter_web_fe/core/services/api_service.dart';
import 'dart:convert';

class CheckoutService {
  final ApiClient apiClient;

  CheckoutService(this.apiClient);

  Future<OrderDetail> submitOrder({
    required int productId,
    required int quantity,
    String? name,
    String? phone,
    String? address,
    String? paymentMethod,
  }) async {
    try {
      final response = await apiClient.post('/yeucaumua/create/', {
        'sanpham_id': productId,
        'soluong': quantity,
        'httt_id': paymentMethod,
      });

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return OrderDetail.fromJson(data);
      } else {
        throw Exception('Lỗi khi gửi đơn hàng: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi gửi đơn hàng: $e');
    }
  }
}
