import 'package:flutter_web_fe/core/data/models/my_order_model.dart';
import 'package:flutter_web_fe/core/data/models/order_model.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<OrderDetail> orders;

  OrderLoaded(this.orders);
}

class OrderListLoaded extends OrderState {
  final List<Order> orderLists;

  OrderListLoaded(this.orderLists);
}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);
}
