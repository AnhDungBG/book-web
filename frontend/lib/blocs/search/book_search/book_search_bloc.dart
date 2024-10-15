import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/search/book_search/book_search_event.dart';
import 'package:flutter_web_fe/blocs/search/book_search/book_search_state.dart';

import 'package:flutter_web_fe/core/data/repositories/book_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductService productSearchService;

  SearchBloc({required this.productSearchService}) : super(SearchInitial()) {
    on<PerformSearch>(_onPerformSearch);
    on<ClearSearch>(_onClearSearch);
  }

  void _onPerformSearch(PerformSearch event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final products = await productSearchService.searchProducts(
        page: event.page,
        limit: event.limit,
        searchQuery: event.query,
      );
      emit(SearchLoaded(
        results: products,
        totalResults: products.length,
        hasReachedMax: products.length < event.limit,
      ));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }
}
