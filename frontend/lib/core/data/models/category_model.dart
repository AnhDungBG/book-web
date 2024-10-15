class Categories {
  final int id;
  final String ten;

  Categories({required this.id, required this.ten});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['id'],
      ten: json['ten'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ten': ten,
    };
  }
}
