import 'package:equatable/equatable.dart';

abstract class MyFavoriteProductEvent extends Equatable {
  const MyFavoriteProductEvent();

  @override
  List<Object> get props => [];
}

class FetchMyFavoriteProducts extends MyFavoriteProductEvent {
  const FetchMyFavoriteProducts();
}

// Sự kiện mới để xóa sản phẩm
class RemoveMyFavoriteProduct extends MyFavoriteProductEvent {
  final int favoriteId;

  const RemoveMyFavoriteProduct(this.favoriteId);

  @override
  List<Object> get props => [favoriteId];
}

class AddMyFavoriteProduct extends MyFavoriteProductEvent {
  final int productid;

  const AddMyFavoriteProduct(this.productid);

  @override
  List<Object> get props => [productid];
}
