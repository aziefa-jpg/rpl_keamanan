import 'package:flutter/material.dart';
import '../config/dependency_injector.dart';
import '../services/auth_storage_service.dart';

/// Screen untuk pengujian Latihan 4 (Secure Storage).
class TokenDemoScreen extends StatefulWidget {
  final AuthStorageService? storageService;

  const TokenDemoScreen({super.key, this.storageService});

  @override
  State<TokenDemoScreen> createState() => _TokenDemoScreenState();
}

class _TokenDemoScreenState extends State<TokenDemoScreen> {
  late final AuthStorageService _storageService;
  final _tokenController = TextEditingController();

  String _currentStatus = 'Memeriksa token...';
  String? _savedToken;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _storageService = widget.storageService ?? locator.authStorageService;
    _checkTokenStatus();
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _checkTokenStatus() async {
    setState(() => _isLoading = true);
    final token = await _storageService.getToken();
    setState(() {
      _savedToken = token;
      _currentStatus = token != null ? 'Token Tersimpan' : 'Belum Ada Token';
      _isLoading = false;
    });
  }

  Future<void> _saveToken() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan teks token terlebih dahulu!')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await _storageService.saveToken(token);
    _tokenController.clear();
    await _checkTokenStatus();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Token berhasil disimpan secara aman!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _deleteToken() async {
    setState(() => _isLoading = true);
    await _storageService.deleteToken();
    await _checkTokenStatus();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🗑️ Token berhasil dihapus!'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 4: Secure Storage'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: _savedToken != null
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status: $_currentStatus',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: _savedToken != null
                                  ? Colors.green.shade900
                                  : Colors.red.shade900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Value: ${_savedToken ?? "(kosong)"}',
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _tokenController,
                    decoration: const InputDecoration(
                      labelText: 'Simulasikan Dummy JWT Token',
                      hintText: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.key),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _saveToken,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan Token'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _savedToken != null ? _deleteToken : null,
                    icon: const Icon(Icons.delete),
                    label: const Text('Hapus Token'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}