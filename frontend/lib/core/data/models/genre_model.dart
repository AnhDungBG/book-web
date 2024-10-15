class Genre {
  final int id;
  final String name;
  final String? imageUrl;
  final int? bookCount;

  Genre({
    required this.id,
    required this.name,
    this.imageUrl,
    this.bookCount,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      bookCount: json['book_count'],
    );
  }
}
