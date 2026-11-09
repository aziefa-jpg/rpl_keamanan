import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

/// Class Exception kustom untuk menangani error respons API
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Request GET umum (tanpa/dengan Auth Header)
  Future<dynamic> get(String endpoint, {String? token}) async {
    final baseUrl = AppConfig.apiBaseUrl;
    final uri = Uri.parse('$baseUrl$endpoint');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    try {
      debugPrint('[GET] $uri');
      final response = await _client.get(uri, headers: headers);
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Terjadi kesalahan tidak terduga: $e');
    }
  }

  /// Penanganan HTTP Status Code (Latihan 5)
  dynamic _handleResponse(http.Response response) {
    debugPrint('Response Status Code: ${response.statusCode}');

    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw ApiException('Permintaan tidak valid (400 Bad Request).', 400);
      case 401:
        throw ApiException('Sesi berakhir atau token tidak valid (401 Unauthorized).', 401);
      case 403:
        throw ApiException('Akses ditolak (403 Forbidden).', 403);
      case 404:
        throw ApiException('Data tidak ditemukan (404 Not Found).', 404);
      case 500:
      default:
        throw ApiException('Terjadi kesalahan server (${response.statusCode}).', response.statusCode);
    }
  }
}