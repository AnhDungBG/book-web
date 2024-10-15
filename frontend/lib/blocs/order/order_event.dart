import 'package:flutter_web_fe/core/data/models/order_model.dart';

abstract class OrderEvent {}

class FetchOrders extends OrderEvent {}

class SendOrderRequest extends OrderEvent {
  final OrderDetail order;

  SendOrderRequest(this.order);
}

class CancelOrder extends OrderEvent {
  final int orderId;

  CancelOrder(this.orderId);
}
