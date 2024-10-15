import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/topProduct/top_product_event.dart';
import 'package:flutter_web_fe/blocs/topProduct/top_product_state.dart';
import 'package:flutter_web_fe/core/data/repositories/book_repository.dart';

class TopBookBloc extends Bloc<TopBookEvent, TopBookState> {
  final ProductService productService;

  TopBookBloc({required this.productService}) : super(TopBooksLoading()) {
    on<FetchTopBooks>(_onFetchTopBooks);
  }

  void _onFetchTopBooks(FetchTopBooks event, Emitter<TopBookState> emit) async {
    emit(TopBooksLoading());
    try {
      final topBooks = await productService.getTopBooks();
      emit(TopBooksLoaded(topBooks));
    } catch (e) {
      emit(TopBooksError(e.toString()));
    }
  }
}
