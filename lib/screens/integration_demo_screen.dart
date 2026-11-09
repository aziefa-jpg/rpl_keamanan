import 'package:flutter/material.dart';
import '../config/dependency_injector.dart';
import '../services/api_service.dart';
import '../services/auth_storage_service.dart';

/// Screen Pengujian Latihan 5 (Integrasi Auth & Response Handling).
class IntegrationDemoScreen extends StatefulWidget {
  final ApiService? apiService;
  final AuthStorageService? storageService;

  const IntegrationDemoScreen({
    super.key,
    this.apiService,
    this.storageService,
  });

  @override
  State<IntegrationDemoScreen> createState() => _IntegrationDemoScreenState();
}

class _IntegrationDemoScreenState extends State<IntegrationDemoScreen> {
  late final ApiService _apiService;
  late final AuthStorageService _storageService;

  bool _isLoading = false;
  String? _resultMessage;
  bool _isError = false;
  String? _activeToken;

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? locator.apiService;
    _storageService = widget.storageService ?? locator.authStorageService;
    _loadCurrentToken();
  }

  Future<void> _loadCurrentToken() async {
    final token = await _storageService.getToken();
    setState(() {
      _activeToken = token;
    });
  }

  /// 1. Menguji Request Sukses (Endpoint Valid: /posts/1)
  Future<void> _fetchDataSuccess() async {
    _executeApiCall('/posts/1');
  }

  /// 2. Menguji Error 404 (Endpoint Tidak Ada: /invalid-endpoint)
  Future<void> _fetchDataNotFound() async {
    _executeApiCall('/invalid-endpoint-404');
  }

  /// Eksekusi panggilan API + pembacaan Token dari Secure Storage
  Future<void> _executeApiCall(String endpoint) async {
    setState(() {
      _isLoading = true;
      _resultMessage = null;
      _isError = false;
    });

    try {
      // Ambil token tersimpan
      final token = await _storageService.getToken();

      // Kirim GET request dengan token
      final response = await _apiService.get(endpoint, token: token);

      setState(() {
        _isLoading = false;
        _isError = false;
        _resultMessage = '✅ Response Sukses:\n\n${response.toString()}';
      });
    } on ApiException catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
        _resultMessage =
            '❌ Handled Exception (${e.statusCode ?? "Network"}):\n${e.message}';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
        _resultMessage = '❌ Error Tidak Terduga:\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 5: Integrasi & Auth API'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Info Status Token
            Card(
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(Icons.shield, color: Colors.deepPurple),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _activeToken != null
                            ? 'Token Active: ${_activeToken!.substring(0, _activeToken!.length > 15 ? 15 : _activeToken!.length)}...'
                            : 'Token Status: Tidak Ada (Public Request)',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _fetchDataSuccess,
              icon: const Icon(Icons.check_circle),
              label: const Text('Uji Request API Sukses (200 OK)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _fetchDataNotFound,
              icon: const Icon(Icons.error_outline),
              label: const Text('Uji Response Error (404 Not Found)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Hasil Penanganan Response / Error:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isError ? Colors.red.shade50 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isError ? Colors.red.shade300 : Colors.grey.shade300,
                  ),
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Text(
                          _resultMessage ?? 'Pilih salah satu pengujian di atas.',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: _isError ? Colors.red.shade900 : Colors.black87,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}