// my_favorite_product_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_web_fe/core/data/models/book_model.dart';
import 'package:flutter_web_fe/core/data/models/my_favorite_model.dart';

abstract class MyFavoriteProductState extends Equatable {
  const MyFavoriteProductState();

  @override
  List<Object?> get props => [];
}

class MyFavoriteProductsLoading extends MyFavoriteProductState {}

class MyFavoriteProductsLoaded extends MyFavoriteProductState {
  final List<FavoriteProduct> myFavoriteProducts;

  const MyFavoriteProductsLoaded(this.myFavoriteProducts);

  @override
  List<Object?> get props => [myFavoriteProducts];
}

class MyFavoriteProductsError extends MyFavoriteProductState {
  final String error;

  const MyFavoriteProductsError(this.error);

  @override
  List<Object?> get props => [error];
}

class MyFavoriteProductAdded extends MyFavoriteProductState {
  final Product productId;

  const MyFavoriteProductAdded(this.productId);

  @override
  List<Object?> get props => [productId];
}

class MyFavoriteProductActionSuccess extends MyFavoriteProductState {
  final String message;

  const MyFavoriteProductActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class MyFavoriteProductActionError extends MyFavoriteProductState {
  final String error;

  const MyFavoriteProductActionError(this.error);

  @override
  List<Object?> get props => [error];
}
