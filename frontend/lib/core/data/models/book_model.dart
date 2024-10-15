class Product {
  final int id;
  final String? title; // Product title
  final String? author; // Product author
  final double? price; // Purchase price
  final double? borrowingPrice; // Borrowing price
  final double? marketPrice; // Market price
  final String? shortDescription; // Short description
  final String? description; // Detailed description
  final DateTime? publicationDate; // Publication date
  final int? quantity; // Available quantity
  final String? imageUrl; // Image URL
  final List<Tag>? tags; // List of tags
  final String? type; // Product type
  final Manufacturer? manufacturer; // Manufacturer details
  final Promotion? promotion; // Promotion details
  final int soldCount; // Total sold count
  final double rating; // Product rating

  Product({
    required this.id,
    this.title,
    this.author,
    this.price,
    this.borrowingPrice,
    this.marketPrice,
    this.shortDescription,
    this.description,
    this.publicationDate,
    this.quantity,
    this.imageUrl,
    this.promotion,
    this.tags,
    this.type,
    this.manufacturer,
    this.soldCount = 0,
    this.rating = 0.0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['ten'] ?? '', // Ensure it's not null
      author: json['tacgia'] ?? '', // Ensure it's not null
      price: json['giamua'] != null
          ? double.tryParse(json['giamua'].toString())
          : null,
      borrowingPrice: json['giamuon'] != null
          ? double.tryParse(json['giamuon'].toString())
          : null,
      marketPrice: json['giathitruong'] != null
          ? double.tryParse(json['giathitruong'].toString())
          : null,
      shortDescription: json['motangan'] ?? '', // Ensure it's not null
      description: json['motachitiet'] ?? '', // Ensure it's not null
      imageUrl: json['hinhanh'] ?? '', // Ensure it's not null
      publicationDate: json['ngayxuatban'] != null
          ? DateTime.tryParse(json['ngayxuatban'])
          : null,
      quantity: json['soluong'] ?? 0, // Ensure it's not null
      promotion: json['khuyenmai'] != null
          ? Promotion.fromJson(json['khuyenmai'])
          : null,
      tags: (json['tags'] as List<dynamic>?)
          ?.map((tag) => Tag.fromJson(tag))
          .toList(),
      type: json['loai']?['ten'] ?? '', // Ensure it's not null
      manufacturer:
          json['nsx'] != null ? Manufacturer.fromJson(json['nsx']) : null,
      soldCount: json['soluongdaban'] ?? 0,
      rating: (json['danhgia'] != null)
          ? double.tryParse(json['danhgia'].toString()) ?? 0.0
          : 0.0,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, title: $title, author: $author, price: $price, rating: $rating}';
  }

  // Returns null (might need to be implemented properly)
  get pageCount => null;

  // Converts Product to JSON for sending to the API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ten': title,
      'tacgia': author,
      'giamua': price?.toString(),
      'giamuon': borrowingPrice?.toString(),
      'giathitruong': marketPrice?.toString(),
      'motangan': shortDescription,
      'motachitiet': description,
      'hinhanh': imageUrl,
      'ngayxuatban': publicationDate?.toIso8601String(),
      'soluong': quantity,
      'khuyenmai': promotion?.toJson(),
      'tags': tags?.map((tag) => tag.toJson()).toList(),
      'loai': {'ten': type},
      'nsx': manufacturer?.toJson(),
      'soluongdaban': soldCount,
      'danhgia': rating,
    };
  }
}

class Tag {
  final int id;
  final String name;

  Tag({required this.id, required this.name});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['ten'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ten': name,
    };
  }
}

class Manufacturer {
  final int id;
  final String name;

  Manufacturer({required this.id, required this.name});

  factory Manufacturer.fromJson(Map<String, dynamic> json) {
    return Manufacturer(
      id: json['id'],
      name: json['ten'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ten': name,
    };
  }
}

class Promotion {
  final int? id;
  final String? name;
  final double? discount;
  final String? type;
  final String? content;
  final DateTime? startDate;
  final DateTime? endDate;

  Promotion({
    this.id,
    this.name,
    this.discount,
    this.type,
    this.content,
    this.startDate,
    this.endDate,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'],
      name: json['ten'],
      discount: double.tryParse(json['khuyenmai']?.toString() ?? '0') ?? 0,
      type: json['loaikhuyenmai'],
      content: json['noidung'],
      startDate:
          json['tungay'] != null ? DateTime.tryParse(json['tungay']) : null,
      endDate:
          json['denngay'] != null ? DateTime.tryParse(json['denngay']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ten': name,
      'khuyenmai': discount.toString(),
      'loaikhuyenmai': type,
      'noidung': content,
      'tungay': startDate?.toIso8601String(),
      'denngay': endDate?.toIso8601String(),
    };
  }
}
