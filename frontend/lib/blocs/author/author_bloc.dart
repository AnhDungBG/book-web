import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/author/author_event.dart';
import 'package:flutter_web_fe/blocs/author/author_state.dart';
import 'package:flutter_web_fe/core/data/repositories/author_repository.dart';

class AuthorBloc extends Bloc<AuthorEvent, AuthorState> {
  final AuthorService authorService;
  AuthorBloc({required this.authorService})
      : super(AuthorLoading() as AuthorState) {
    on<FetchAuthor>(_onFetchAuthor);
  }

  void _onFetchAuthor(AuthorEvent event, Emitter emit) async {
    emit(AuthorLoading());
    try {
      final author = await authorService.getCategories();
      emit(AuthorLoaded(author));
    } catch (e) {
      emit(AuthorError(e.toString()));
    }
  }
}
