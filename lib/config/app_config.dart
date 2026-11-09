import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get apiBaseUrl {
    if (dotenv.isInitialized) {
      return dotenv.env['BASE_URL'] ?? 'https://jsonplaceholder.typicode.com';
    }
    return 'https://jsonplaceholder.typicode.com';
  }
}