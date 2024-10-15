class Author {
  final String id;
  final String name;
  final String bio;
  final String avatarUrl;

  Author({
    required this.id,
    required this.name,
    required this.bio,
    required this.avatarUrl,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      name: json['name'],
      bio: json['bio'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'avatarUrl': avatarUrl,
    };
  }
}
