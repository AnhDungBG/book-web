import 'package:equatable/equatable.dart';
import 'package:flutter_web_fe/core/data/models/cart_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartStarted extends CartEvent {}

class CartItemAdded extends CartEvent {
  final CartItemModel item;

  const CartItemAdded(this.item);

  @override
  List<Object?> get props => [item];
}

class CartItemRemoved extends CartEvent {
  final String itemId;

  const CartItemRemoved(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class CartItemQuantityChanged extends CartEvent {
  final String itemId;
  final int quantity;

  const CartItemQuantityChanged(this.itemId, this.quantity);

  @override
  List<Object?> get props => [itemId, quantity];
}

class CartCleared extends CartEvent {}
