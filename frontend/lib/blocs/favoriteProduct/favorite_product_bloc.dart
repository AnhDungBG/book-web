import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/favoriteProduct/favorite_product_event.dart';
import 'package:flutter_web_fe/blocs/favoriteProduct/favorite_product_state.dart';
import 'package:flutter_web_fe/core/data/repositories/book_repository.dart';

class FavoriteProductBloc
    extends Bloc<FavoriteProductEvent, FavoriteProductState> {
  final ProductService productService;

  FavoriteProductBloc({required this.productService})
      : super(FavoriteProductsLoading()) {
    on<FetchFavoriteProduct>(_onFetchFavoriteProduct);
  }

  void _onFetchFavoriteProduct(
      FetchFavoriteProduct event, Emitter<FavoriteProductState> emit) async {
    emit(FavoriteProductsLoading());
    try {
      final favoriteProducts = await productService.getTopFavoriteBooks();
      emit(FavoriteProductsLoaded(favoriteProducts));
    } catch (e) {
      emit(FavoriteProductsError(e.toString()));
    }
  }
}
