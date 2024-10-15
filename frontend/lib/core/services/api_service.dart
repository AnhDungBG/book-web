// ignore_for_file: unused_field

import 'dart:convert';
import 'package:flutter_web_fe/core/config/config.dart';
import 'package:flutter_web_fe/core/data/models/auth_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final String baseUrl = Config.baseUrl;
  String? _authToken;
  User? _user;

  void setAuthToken(String? token) => _authToken = token;
  void setUser(User? user) => _user = user;

  Map<String, String> _createHeaders() {
    final headers = {'Content-Type': 'application/json; charset=utf-8'};
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  void clearUser() {
    _user = null;
    _authToken = null;
  }

  Future<http.Response> delete(String endpoint) async {
    return _sendRequest(() => http.delete(
          Uri.parse('$baseUrl$endpoint'),
          headers: _createHeaders(),
        ));
  }

  Future<http.Response> _sendRequest(
      Future<http.Response> Function() request) async {
    try {
      final response = await request();
      _checkResponseStatus(response, request);
      return response;
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  Future<http.Response> get(String endpoint,
      {Map<String, String>? params}) async {
    Uri uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
    return _sendRequest(() => http.get(uri, headers: _createHeaders()));
  }

  Future<http.Response> post(String endpoint, data) async {
    return _sendRequest(() => http.post(
          Uri.parse('$baseUrl$endpoint'),
          headers: _createHeaders(),
          body: jsonEncode(data),
        ));
  }

  Future<http.Response> put(String endpoint) async {
    return _sendRequest(() => http.put(
          Uri.parse('$baseUrl$endpoint'),
          headers: _createHeaders(),
        ));
  }

  Future<void> _checkResponseStatus(http.Response response,
      Future<http.Response> Function() retryRequest) async {
    if (response.statusCode == 401) {
      await _refreshAccessToken();
      await retryRequest();
    } else if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> _refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refresh_token');

    if (refreshToken != null) {
      final response = await http.post(
        Uri.parse('$baseUrl/refresh-token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final newAuthToken = jsonDecode(response.body)['access_token'];
        _authToken = newAuthToken;

        await prefs.setString('access_token', newAuthToken);
      } else {
        throw Exception('Failed to refresh token');
      }
    } else {
      throw Exception('No refresh token available');
    }
  }
}
