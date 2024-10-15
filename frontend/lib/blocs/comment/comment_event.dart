abstract class CommentEvent {}

class FetchComments extends CommentEvent {
  final String productId;

  FetchComments(this.productId);
}
