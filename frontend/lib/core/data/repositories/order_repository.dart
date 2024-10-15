import 'dart:convert';
import 'package:flutter_web_fe/core/data/models/my_order_model.dart';
import 'package:flutter_web_fe/core/data/models/order_model.dart';
import 'package:flutter_web_fe/core/services/api_service.dart';

class OrderService {
  final ApiClient apiClient;
  OrderService(this.apiClient);

  // Send a new order
  Future<OrderDetail> sendOrder(OrderDetail order) async {
    try {
      final response = await apiClient.post('/yeucaumua/create/', {
        'sanpham_id': order.productId,
        'soluong': order.quantity,
        'httt_id': order.paymentMethod,
      });

      if (response.statusCode == 201) {
        final utf8Response = utf8.decode(response.bodyBytes);
        final data = jsonDecode(utf8Response);
        return OrderDetail.fromJson(data);
      } else {
        throw Exception('Lỗi khi gửi đơn hàng: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi gửi đơn hàng: $e');
    }
  }

  // Fetch the list of orders
  Future<List<Order>> fetchListOrders() async {
    try {
      final response = await apiClient.get('/yeucaumua/');

      if (response.statusCode == 200) {
        final utf8Response = utf8.decode(response.bodyBytes);
        final data = jsonDecode(utf8Response);

        final List<dynamic> orderList = data['results'] ?? data;

        return orderList.map((order) => Order.fromJson(order)).toList();
      } else {
        throw Exception(
            'Lỗi khi tải danh sách đơn hàng: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi tải danh sách đơn hàng: $e');
    }
  }

  // Fetch the list of orders
  Future<void> cancelOrder(int orderId) async {
    final response = await apiClient.put('/yeucaumua/$orderId/huy/');

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel order: ${response.body}');
    }
  }
}
