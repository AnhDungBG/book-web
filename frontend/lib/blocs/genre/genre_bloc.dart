import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/genre/genre_event.dart';
import 'package:flutter_web_fe/blocs/genre/genre_state.dart';
import 'package:flutter_web_fe/core/data/repositories/genre_repository.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  final GenreService genreService;

  GenreBloc({required this.genreService}) : super(GenreInitial()) {
    on<FetchGenres>(_onFetchGenres);
  }

  void _onFetchGenres(FetchGenres event, Emitter<GenreState> emit) async {
    emit(GenreLoading());
    try {
      final genres = await genreService.getGenres();
      emit(GenreLoaded(genres));
    } catch (e) {
      emit(GenreError(e.toString()));
    }
  }
}
