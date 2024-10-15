import 'package:equatable/equatable.dart';
import 'package:flutter_web_fe/core/data/models/cart_model.dart';
import 'package:flutter_web_fe/core/data/models/order_model.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {
  final OrderDetail orderDetail;

  const CheckoutSuccess(this.orderDetail);
}

class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object?> get props => [message];
}

class CheckoutLoaded extends CheckoutState {
  final CartModel cart;
  final double totalPrice;
  final String? name;
  final String? phone;
  final String? address;
  final String? paymentMethod;

  const CheckoutLoaded({
    required this.cart,
    required this.totalPrice,
    this.name,
    this.phone,
    this.address,
    this.paymentMethod,
  });

  @override
  List<Object?> get props =>
      [cart, totalPrice, name, phone, address, paymentMethod];

  CheckoutLoaded copyWith({
    CartModel? cart,
    double? totalPrice,
    String? name,
    String? phone,
    String? address,
    String? paymentMethod,
  }) {
    return CheckoutLoaded(
      cart: cart ?? this.cart,
      totalPrice: totalPrice ?? this.totalPrice,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
