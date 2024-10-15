import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/comment/comment_event.dart';
import 'package:flutter_web_fe/blocs/comment/comment_state.dart';
import 'package:flutter_web_fe/core/data/repositories/book_repository.dart';

class CommentsBloc extends Bloc<CommentEvent, CommentsState> {
  final ProductService productService;

  CommentsBloc(this.productService) : super(CommentsInitial()) {
    on<FetchComments>(_onFetchComments);
  }

  void _onFetchComments(CommentEvent event, Emitter emit) async {
    emit(CommentsLoading());

    if (event is FetchComments) {
      try {
        final res =
            await productService.getCommentsByProductId(event.productId);
        emit(CommentsLoaded(res));
      } catch (e) {
        emit(CommentsError(e.toString()));
      }
    }
  }
}
