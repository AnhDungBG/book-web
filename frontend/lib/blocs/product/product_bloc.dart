import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/product/product_sate.dart';
import 'package:flutter_web_fe/core/data/repositories/book_repository.dart';
import 'product_event.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService productService;

  ProductBloc({required this.productService}) : super(ProductInitial()) {
    on<FetchProductDetail>(_onFetchProductDetail);
    on<FetchRelatedProducts>(_onFetchRelatedProducts);
    on<FetchProducts>(_onFetchProducts);
    // on<FetchProductsByTags>(_onFetchProductsByTags);
    on<FetchProductSales>(_onFetchProductSales);
  }

  void _onFetchProducts(FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());

    try {
      final products = await productService.getProducts(
        page: event.page,
        limit: event.limit,
        categories: event.categories,
        priceRange: event.priceRange,
        authors: event.authors,
        searchQuery: event.searchQuery,
      );
      emit(ProductsLoaded(products, count: products.length));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  // void _onFetchProductsByTags(
  //     FetchProductsByTags event, Emitter<ProductState> emit) async {
  //   emit(ProductTagsLoading());
  //   try {
  //     final products = await productService.getProductsTags(tags: event.tags);
  //     emit(ProductLoaded(products));
  //   } catch (e) {
  //     emit(TagsProductsError(e.toString()));
  //   }
  // }

  Future<void> _onFetchProductDetail(
      FetchProductDetail event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final product = await productService.getProductDetail(event.productId);
      final relatedProducts =
          await productService.getRelatedProducts(event.productId);
      emit(ProductDetailLoaded(product, relatedProducts: relatedProducts));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onFetchRelatedProducts(
      FetchRelatedProducts event, Emitter<ProductState> emit) async {
    try {
      final relatedProducts =
          await productService.getRelatedProducts(event.productId);
      if (state is ProductDetailLoaded) {
        final currentState = state as ProductDetailLoaded;
        emit(ProductDetailLoaded(currentState.product,
            relatedProducts: relatedProducts));
      } else {
        emit(RelatedProductsLoaded(relatedProducts));
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching related products: ${e.toString()}');
    }
  }

  void _onFetchProductSales(
      FetchProductSales event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final productSales = await productService.getProductSales();
      emit(ProductSalesLoaded(productSales));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
