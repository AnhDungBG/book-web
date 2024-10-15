import 'package:equatable/equatable.dart';

abstract class FavoriteProductEvent extends Equatable {
  const FavoriteProductEvent();

  @override
  List<Object?> get props => [];
}

class FetchFavoriteProduct extends FavoriteProductEvent {
  const FetchFavoriteProduct();

  @override
  List<Object?> get props => [];
}
