import 'dart:convert';

import 'package:flutter_web_fe/core/data/models/author_model.dart';
import 'package:flutter_web_fe/core/services/api_service.dart';

class AuthorService {
  final ApiClient apiClient;
  AuthorService(this.apiClient);
  Future<List<Author>> getCategories() async {
    final response = await apiClient.get('/author');
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];

      return results.map((item) => Author.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load authors');
    }
  }
}
