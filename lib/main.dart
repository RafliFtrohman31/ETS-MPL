import 'package:flutter/material.dart';
import 'core/di/injection.dart'; 
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart'; // Import router Anda

void main() {
  // Menjamin framework Flutter sudah siap sebelum memanggil setupLocator
  WidgetsFlutterBinding.ensureInitialized();
  
  // WAJIB: Memanggil registrasi Dependency Injection[cite: 6]
  setupLocator(); 
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengubah MaterialApp menjadi MaterialApp.router agar mendukung GoRouter[cite: 6]
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'UTD Store Rafly',
      theme: AppTheme.lightTheme, // Memanggil tema global[cite: 7]
      
      // Menghubungkan konfigurasi router yang kita buat di AppRouter[cite: 6]
      routerConfig: AppRouter.router, 
    );
  }
}