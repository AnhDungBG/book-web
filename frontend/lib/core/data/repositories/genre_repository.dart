import 'dart:convert';
import 'package:flutter_web_fe/core/data/models/genre_model.dart';
import 'package:flutter_web_fe/core/services/api_service.dart';

class GenreService {
  final ApiClient apiClient;

  GenreService(this.apiClient);

  Future<List<Genre>> getGenres() async {
    final response = await apiClient.get('/loaisanpham');

    if (response.statusCode == 200) {
      final utf8Response = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> data = jsonDecode(utf8Response);
      final List<dynamic> results = data['results'];

      return results.map((item) => Genre.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load genres');
    }
  }
}
