import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service untuk mengelola penyimpanan token autentikasi secara aman.
class AuthStorageService {
  final FlutterSecureStorage _storage;

  static const String _tokenKey = 'auth_token';

  AuthStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Menyimpan token autentikasi ke dalam secure storage.
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Membaca token autentikasi dari secure storage.
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Menghapus token autentikasi dari secure storage (logout).
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Memeriksa apakah pengguna memiliki token aktif.
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}