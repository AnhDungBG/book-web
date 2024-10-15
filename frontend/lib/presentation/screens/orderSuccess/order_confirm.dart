import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class OrderConfirmationPage extends StatelessWidget {
  final int orderId;
  final String orderDate;
  final String deliveryAddress;
  final bool paymentStatus;
  final String paymentMethod;
  final String phoneNumber;
  final int productId;
  final int quantity;
  final String unitPrice;

  const OrderConfirmationPage({
    super.key,
    required this.orderId,
    required this.orderDate,
    required this.deliveryAddress,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.phoneNumber,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận đơn hàng'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Thêm cuộn cho nội dung
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Thông tin đơn hàng',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildOrderDetail('ID đơn hàng', '$orderId'),
              _buildOrderDetail('Ngày đặt', orderDate),
              _buildOrderDetail('Nơi giao', deliveryAddress),
              _buildOrderDetail('Trạng thái thanh toán',
                  paymentStatus ? "Đã thanh toán" : "Chưa thanh toán"),
              _buildOrderDetail('Phương thức thanh toán', paymentMethod),
              _buildOrderDetail('Số điện thoại', phoneNumber),
              _buildOrderDetail('Sản phẩm ID', '$productId'),
              _buildOrderDetail('Số lượng', '$quantity'),
              _buildOrderDetail('Đơn giá', '$unitPrice đ'),
              const SizedBox(height: 50),
              // Căn giữa nút
              ElevatedButton(
                onPressed: () {
                  Beamer.of(context).beamToNamed('/products/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Quay lại trang sản phẩm'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm hỗ trợ để tạo các dòng thông tin
  Widget _buildOrderDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text('$title: $value', style: const TextStyle(fontSize: 16)),
    );
  }
}
