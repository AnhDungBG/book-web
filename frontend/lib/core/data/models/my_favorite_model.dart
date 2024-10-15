import 'package:flutter_web_fe/core/data/models/auth_model.dart';
import 'package:flutter_web_fe/core/data/models/book_model.dart';

class FavoriteProductResponse {
  final int count;
  final List<FavoriteProduct> results;

  FavoriteProductResponse({required this.count, required this.results});

  factory FavoriteProductResponse.fromJson(Map<String, dynamic> json) {
    var resultsList = json['results'] as List;
    List<FavoriteProduct> results =
        resultsList.map((i) => FavoriteProduct.fromJson(i)).toList();

    return FavoriteProductResponse(
      count: json['count'],
      results: results,
    );
  }
}

class FavoriteProduct {
  final int id;
  final User customer;
  final Product product;

  FavoriteProduct(
      {required this.id, required this.customer, required this.product});

  factory FavoriteProduct.fromJson(Map<String, dynamic> json) {
    return FavoriteProduct(
      id: json['id'],
      customer: User.fromJson(json['khachhang']),
      product: Product.fromJson(json['sanpham']),
    );
  }
}
