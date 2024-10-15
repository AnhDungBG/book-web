import 'dart:convert';

import 'package:flutter_web_fe/core/services/api_service.dart';
import 'package:flutter_web_fe/core/data/models/category_model.dart';

class CategoryService {
  final ApiClient apiClient;
  CategoryService(this.apiClient);
  Future<List<Categories>> getCategories() async {
    final response = await apiClient.get('/loaisanpham');

    if (response.statusCode == 200) {
      final utf8Response = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> data = jsonDecode(utf8Response);
      final List<dynamic> results = data['results'];

      return results.map((item) => Categories.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
