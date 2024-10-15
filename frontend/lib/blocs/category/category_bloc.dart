import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/category/category_event.dart';
import 'package:flutter_web_fe/blocs/category/category_state.dart';
import 'package:flutter_web_fe/core/data/repositories/category_repository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryService categoryService;
  CategoryBloc({required this.categoryService}) : super(CategoryLoading()) {
    on<FetchCategory>(_onFetchCategory);
  }

  void _onFetchCategory(CategoryEvent event, Emitter emit) async {
    emit(CategoryLoading());
    try {
      final categories = await categoryService.getCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
