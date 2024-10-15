import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/myFavoriteProduct/my_favorite_event.dart';
import 'package:flutter_web_fe/blocs/myFavoriteProduct/my_favorite_state.dart';
import 'package:flutter_web_fe/core/data/models/my_favorite_model.dart';
import 'package:flutter_web_fe/core/data/repositories/book_repository.dart';

class MyFavoriteProductBloc
    extends Bloc<MyFavoriteProductEvent, MyFavoriteProductState> {
  final ProductService productService;

  MyFavoriteProductBloc({required this.productService})
      : super(MyFavoriteProductsLoading()) {
    on<FetchMyFavoriteProducts>(_onFetchMyFavoriteProducts);
    on<RemoveMyFavoriteProduct>(_onRemoveMyFavoriteProduct);
    on<AddMyFavoriteProduct>(_onAddMyFavoriteProduct);
  }
  Future<void> _onFetchMyFavoriteProducts(FetchMyFavoriteProducts event,
      Emitter<MyFavoriteProductState> emit) async {
    emit(MyFavoriteProductsLoading());
    try {
      final myFavoriteProducts = await productService.getMyFavoriteBooks();
      emit(MyFavoriteProductsLoaded(myFavoriteProducts));
    } catch (e) {
      emit(MyFavoriteProductsError(e.toString()));
    }
  }

  Future<void> _onRemoveMyFavoriteProduct(RemoveMyFavoriteProduct event,
      Emitter<MyFavoriteProductState> emit) async {
    emit(MyFavoriteProductsLoading());
    try {
      await productService.removeFavoriteBook(event.favoriteId);

      await _onFetchMyFavoriteProducts(const FetchMyFavoriteProducts(), emit);
    } catch (e) {
      emit(MyFavoriteProductsError(e.toString()));
    }
  }

  Future<void> _onAddMyFavoriteProduct(
      AddMyFavoriteProduct event, Emitter<MyFavoriteProductState> emit) async {
    emit(MyFavoriteProductsLoading());
    try {
      await productService.addFavoriteBook(event.productid);
      if (state is MyFavoriteProductsLoaded) {
        final updatedProducts = List<FavoriteProduct>.from(
            (state as MyFavoriteProductsLoaded).myFavoriteProducts);
        emit(MyFavoriteProductsLoaded(updatedProducts));
      }
      emit(MyFavoriteProductActionSuccess(
          'Sản phẩm ID ${event.productid} đã được thêm vào yêu thích.'));
    } catch (e) {
      emit(MyFavoriteProductActionError(e.toString())); // Phát ra lỗi
    }
  }
}
