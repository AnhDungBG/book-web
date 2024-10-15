class Comment {
  final String username;
  final String content;
  final DateTime date;
  final List<int> rating;

  Comment(
      {required this.username,
      required this.content,
      required this.date,
      required this.rating});
}
