import 'dart:convert';
import 'package:flutter_web_fe/core/data/models/my_favorite_model.dart';
import 'package:flutter_web_fe/core/services/api_service.dart';
import 'package:flutter_web_fe/core/data/models/comment_model.dart';
import 'package:flutter_web_fe/core/data/models/book_model.dart';
import 'package:http/src/response.dart';

class ProductService {
  final ApiClient apiClient;
  ProductService(this.apiClient);

  Future<List<Product>> getProducts({
    int page = 1,
    int limit = 10,
    List<String>? categories,
    String? searchQuery,
    List<double>? priceRange,
    List<String>? authors,
  }) async {
    final Map<String, String> params = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (categories != null && categories.isNotEmpty)
        'loai': categories.join(','),
      if (priceRange != null && priceRange.length == 2) ...{
        'giamua_min': priceRange[0].toString(),
        'giamua_max': priceRange[1].toString(),
      },
      if (authors != null && authors.isNotEmpty) 'authors': authors.join(','),
      if (searchQuery != null && searchQuery.isNotEmpty)
        'searchQuery': searchQuery,
    };

    final response = await apiClient.get('/sanpham', params: params);
    if (response.statusCode == 200) {
      final utf8Response = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> data = jsonDecode(utf8Response);
      final List<dynamic> results = data['results'];
      if (results.isEmpty) {
        return [];
      }
      return results.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Product sales
  Future<List<Product>> getProductSales() async {
    final response = await apiClient.get('/product-sale');
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> addFavoriteBook(int productId) async {
    try {
      final response =
          await apiClient.post('/yeuthich/add/', {"sanpham_id": productId});
      if (response.statusCode == 400) {
        throw Exception('Sản phẩm đã yêu thích');
      }
      if (response.statusCode != 201) {
        throw Exception(
            'Failed to add favorite product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding favorite product: $e');
    }
  }

  Future<List<Product>> getTopFavoriteBooks() async {
    try {
      final response = await apiClient.get('/top-sanpham-yeuthich');

      if (response.statusCode == 200) {
        final utf8Response = utf8.decode(response.bodyBytes);
        final List<dynamic> results = jsonDecode(utf8Response);

        if (results.isNotEmpty) {
          return results.map((item) => Product.fromJson(item)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception(
            'Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching favorite products: $e');
    }
  }

  // product_service.dart
  Future<List<FavoriteProduct>> getMyFavoriteBooks() async {
    final response = await apiClient.get('/yeuthich/');
    if (response.statusCode == 200) {
      final utf8Response = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> decodedJson = jsonDecode(utf8Response);

      final List<dynamic> results = decodedJson['results'];
      return results.map((json) => FavoriteProduct.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> removeFavoriteBook(int favoriteId) async {
    final response = await apiClient.delete('/yeuthich/$favoriteId/');

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete favorite product. '
          'Status code: ${response.statusCode}, Response: ${response.body}');
    }

    if (response.statusCode == 200) {
      print('Delete successful: ${response.body}');
    }
  }

  // Product detail

  Future<Product> getProductDetail(String productId) async {
    final response = await apiClient.get('/sanpham/$productId');
    if (response.statusCode == 200) {
      final utf8Response = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> json = jsonDecode(utf8Response);
      return Product.fromJson(json);
    } else {
      throw Exception('Không thể tải chi tiết sản phẩm');
    }
  }

  Future<List<Product>> getProductsByAuthor(String authorName) async {
    final response = await apiClient.get('/product-author/$authorName');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Comment>> getCommentsByProductId(String productId) async {
    final response = await apiClient.get('/product-comment/$productId');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> getRelatedProductsByProductId(String authorName) async {
    final response = await apiClient.get('/product-author/$authorName');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> getProductsTags({required List<String> tags}) async {
    final params = {'tags': tags.join(',')};
    final response = await apiClient.get('/product-tags', params: params);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  Future<List<Product>> getTopBooks() async {
    final response = await apiClient.get('/top-sanpham-yeuthich/');
    if (response.statusCode == 200) {
      final utf8Response = utf8.decode(response.bodyBytes);
      final List<dynamic> results = jsonDecode(utf8Response);
      return results.isNotEmpty
          ? results.map((item) => Product.fromJson(item)).toList()
          : [];
    } else {
      throw Exception('Failed to load top books');
    }
  }

  Future<List<Product>> searchProducts({
    required String searchQuery,
    int page = 1,
    int limit = 10,
  }) async {
    final Map<String, String> params = {
      'page': page.toString(),
      'limit': limit.toString(),
      'searchQuery': searchQuery,
    };

    final response = await apiClient.get('/sanpham/search', params: params);
    if (response.statusCode == 200) {
      final utf8Response = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> data = jsonDecode(utf8Response);
      final List<dynamic> results = data['results'];
      if (results.isEmpty) {
        return [];
      }
      return results.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Không thể tìm kiếm sản phẩm');
    }
  }

  Future<List<Product>> getRelatedProducts(String productId) async {
    final response = await apiClient.get('/sanpham/$productId/related');
    if (response.statusCode == 200) {
      final utf8Response = utf8.decode(response.bodyBytes);
      final List<dynamic> json = jsonDecode(utf8Response);
      return json.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Không thể tải sản phẩm liên quan');
    }
  }
}

extension on Response {
  get data => null;
}
