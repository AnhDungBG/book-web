import 'package:equatable/equatable.dart';
import 'package:flutter_web_fe/core/data/models/book_model.dart';

abstract class FavoriteProductState extends Equatable {
  const FavoriteProductState();

  @override
  List<Object?> get props => [];
}

class FavoriteProductsLoading extends FavoriteProductState {}

class FavoriteProductsLoaded extends FavoriteProductState {
  final List<Product> favoriteProducts;

  const FavoriteProductsLoaded(this.favoriteProducts);

  @override
  List<Object?> get props => [favoriteProducts];
}

class FavoriteProductsError extends FavoriteProductState {
  final String error;

  const FavoriteProductsError(this.error);

  @override
  List<Object?> get props => [error];
}
