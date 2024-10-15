import 'dart:convert';
import 'package:flutter_web_fe/core/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiClient apiClient;
  AuthService(this.apiClient);
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token != null) {
      // Kiểm tra xem token có hợp lệ không bằng cách gọi API
      try {
        var response = await apiClient.get('/userinfo');
        return response.statusCode == 200;
      } catch (e) {
        // Nếu có lỗi khi gọi API, coi như không đăng nhập
        return false;
      }
    }

    return false;
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    var uri = Uri.parse('${apiClient.baseUrl}/token/');
    try {
      var request = http.MultipartRequest('POST', uri);
      request.fields['grant_type'] = 'password';
      request.fields['username'] = username;
      request.fields['password'] = password;
      request.fields['client_id'] = '03AGDNOIABFKcFPw875bcxldwfTXiaTbonAAnYn2';
      request.fields['client_secret'] =
          'MxgtiGcaZls1HHDLBIHAFFBP2Q2sddd8ljnWuZ0vZbByixtVZlTmFj13UirDqUhMtraeb5Hh647eUmXUzRIuL6sp52mSmwc0zZIo3uf86RI7tp4wR2qS9dIWT0aIR3QI';

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        apiClient.setAuthToken(data['access_token']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', data['access_token']);
        await prefs.setString('refresh_token', data['refresh_token']);
        var res = await apiClient.get('/userinfo');
        await prefs.setString('user', jsonEncode(res.body));
        var user = jsonDecode(res.body);
        return {'user': user};
      } else {
        final errorData = jsonDecode(response.body);
        return {'error': errorData['error_description'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'error': 'An error occurred'};
    }
  }

  Future<void> logout() async {
    apiClient.setAuthToken(null);
    apiClient.clearUser();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<Map<String, dynamic>?> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token != null) {
      apiClient.setAuthToken(token);
      var response = await apiClient.get('/userinfo');

      if (response.statusCode == 200) {
        var user = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(user));
        return {'user': user};
      } else {
        final errorData = jsonDecode(response.body);
        return {'error': errorData['error_description'] ?? 'Login failed'};
      }
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      return jsonDecode(userString) as Map<String, dynamic>;
    }
    return null;
  }

  String _decodeUtf8(String input) {
    try {
      return utf8.decode(input.runes.toList());
    } catch (e) {
      return input;
    }
  }

  Future<Map<String, dynamic>> verifyEmail(String email) async {
    try {
      var response = await apiClient.post('/xacthuc-email/', {'email': email});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String message =
            _decodeUtf8(data['message'] ?? 'OTP đã được gửi đến email của bạn');
        return {'success': true, 'message': message};
      } else {
        final errorData = jsonDecode(response.body);
        String decodedError =
            _decodeUtf8(errorData['error'] ?? 'Xác thực email thất bại');
        return {'error': decodedError};
      }
    } catch (e) {
      return {'error': 'Đã xảy ra lỗi'};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      var response =
          await apiClient.post('/xacthuc-otp/', {'email': email, 'otp': otp});
      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        final errorData = jsonDecode(response.body);
        String decodedError =
            _decodeUtf8(errorData['error'] ?? 'Xác thực OTP thất bại');
        return {'error': decodedError};
      }
    } catch (e) {
      return {'error': 'Đã xảy ra lỗi'};
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      var response = await apiClient.post('/dangky/', userData);
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {'user': data['user']};
      } else {
        final errorData = jsonDecode(response.body);
        return {'error': errorData['error'] ?? 'Registration failed'};
      }
    } catch (e) {
      return {'error': 'An error occurred'};
    }
  }
}
