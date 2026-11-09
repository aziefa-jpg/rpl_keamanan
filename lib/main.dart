import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/dependency_injector.dart';
import 'screens/integration_demo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi dotenv wajib dipanggil terlebih dahulu
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Informasi: .env tidak ditemukan, menggunakan fallback ($e)');
  }

  // Inisialisasi locator / service locator
  locator.setup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latihan 5 API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const IntegrationDemoScreen(),
    );
  }
}