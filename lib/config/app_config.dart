import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Konfigurasi aplikasi yang dimuat dari file .env dengan nilai cadangan (fallback).
class AppConfig {
  /// Base URL untuk API (Fallback ke JSONPlaceholder jika .env belum termuat).
  static String get baseUrl {
    try {
      final url = dotenv.env['BASE_URL'];
      if (url != null && url.isNotEmpty) return url;
    } catch (_) {}
    return 'https://jsonplaceholder.typicode.com';
  }

  /// API key untuk autentikasi.
  static String get apiKey {
    try {
      final key = dotenv.env['API_KEY'];
      if (key != null && key.isNotEmpty) return key;
    } catch (_) {}
    return 'dummy_api_key_12345';
  }

  /// Timeout untuk request HTTP (dalam detik).
  static const int timeoutSeconds = 10;

  /// Memeriksa apakah konfigurasi sudah lengkap.
  static bool isConfigured() {
    return baseUrl.isNotEmpty && apiKey.isNotEmpty;
  }
}