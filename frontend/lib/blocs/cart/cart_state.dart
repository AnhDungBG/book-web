import 'package:equatable/equatable.dart';
import 'package:flutter_web_fe/core/data/models/cart_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];

  get cart => null;
}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  @override
  final CartModel cart;

  const CartLoaded(this.cart);

  @override
  List<Object?> get props => [cart];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

class CartNotAuthenticated extends CartState {}
