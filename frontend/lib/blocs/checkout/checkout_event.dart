import 'package:equatable/equatable.dart';
import 'package:flutter_web_fe/core/data/models/book_model.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class CheckoutStarted extends CheckoutEvent {}

class CheckoutInfoUpdated extends CheckoutEvent {
  final String name;
  final String phone;
  final String address;

  const CheckoutInfoUpdated({
    required this.name,
    required this.phone,
    required this.address,
  });

  @override
  List<Object?> get props => [name, phone, address];
}

class PaymentMethodSelected extends CheckoutEvent {
  final String paymentMethod;

  const PaymentMethodSelected(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}

//
class CheckoutSubmitted extends CheckoutEvent {
  final int productId;
  final int quantity;
  final String paymentMethod;

  const CheckoutSubmitted({
    required this.productId,
    required this.quantity,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [productId, quantity, paymentMethod];
}

class CheckouError extends CheckoutEvent {}

class BuyNowRequested extends CheckoutEvent {
  final Product product;
  final int quantity;

  const BuyNowRequested({required this.product, this.quantity = 1});
}
