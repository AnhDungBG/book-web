class OrderDetail {
  final String paymentMethod;
  final int quantity;
  final int productId;
  final int orderId;
  final String customerName;
  final String orderDate;
  final String deliveryAddress;
  final bool paymentStatus;
  final String phoneNumber;
  final String unitPrice;

  OrderDetail({
    required this.paymentMethod,
    required this.quantity,
    required this.productId,
    required this.orderId,
    required this.customerName,
    required this.orderDate,
    required this.deliveryAddress,
    required this.paymentStatus,
    required this.phoneNumber,
    required this.unitPrice,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      productId: json['sanpham'] ?? 0,
      paymentMethod: json['httt'] ?? '',
      quantity: json['soluong'] ?? 0,
      orderId: json['id'] ?? 0,
      customerName: json['khachhang']?.toString() ?? 'Không có tên',
      orderDate: json['ngaydat'] ?? '',
      deliveryAddress: json['noigiao'] ?? 'Không có địa chỉ',
      paymentStatus: json['trangthai_thanhtoan'] ?? false,
      phoneNumber: json['dienthoai'] ?? 'Không có số điện thoại',
      unitPrice: json['dongia']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'paymentMethod': paymentMethod,
      'orderId': orderId,
      'customerName': customerName,
      'orderDate': orderDate,
      'deliveryAddress': deliveryAddress,
      'paymentStatus': paymentStatus,
      'phoneNumber': phoneNumber,
      'unitPrice': unitPrice,
    };
  }
}
