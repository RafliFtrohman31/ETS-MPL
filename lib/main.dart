import 'package:flutter/material.dart';
import 'core/di/injection.dart'; // Import ini[cite: 6]
import 'core/theme/app_theme.dart';

void main() {
  // WAJIB: Panggil pelayan sebelum aplikasi jalan[cite: 6]
  setupLocator(); 
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTD Store Rafly',
      theme: AppTheme.lightTheme,
      home: const Scaffold(
        body: Center(child: Text('Networking & DI Siap!')),
      ),
    );
  }
}