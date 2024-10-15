import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'http://127.0.0.1:8000/';
}
