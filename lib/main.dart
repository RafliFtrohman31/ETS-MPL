import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart'; // Tambahan Modul 9
import 'package:shared_preferences/shared_preferences.dart'; // Tambahan Modul 9
import 'package:intl/intl.dart'; // Tambahan Modul 9
import 'core/di/injection.dart'; 
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart'; 
import 'core/config/env_config.dart'; // Tambahan Modul 11

// =========================================================================
// SETUP WORKMANAGER (MODUL 9)
// =========================================================================

// 1. NAMA TUGAS (Konstanta agar tidak salah ketik)
const String syncTask = "tugas_sinkronisasi_rutin";

// 2. PEKERJA LATAR BELAKANG (Top-Level Function)
// @pragma ini WAJIB memberitahu compiler Dart agar tidak menghapus fungsi ini saat rilis APK.
@pragma('vm:entry-point')
void callbackDispatcher() {
  // Fungsi ini adalah titik masuk saat aplikasi dibangunkan oleh OS
  Workmanager().executeTask((taskName, inputData) async {
    // Mengecek apakah nama tugasnya cocok
    if (taskName == syncTask) {
      try {
        print("Mulai mengambil data dari server secara gaib...");
        // Pura-pura butuh waktu 3 detik
        await Future.delayed(const Duration(seconds: 3));
        
        // Catat jam berapa tugas ini berhasil dikerjakan ke memori HP
        final prefs = await SharedPreferences.getInstance();
        String currentTime = DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.now());
        await prefs.setString("last_sync_time", "Sinkronisasi diam-diam sukses pada: $currentTime");
        print("Tugas Latar Belakang Selesai!");
        
        return Future.value(true); // Lapor ke OS kalau sukses
      } catch (e) {
        print("Tugas gagal: $e");
        return Future.value(false); // Lapor ke OS kalau gagal
      }
    }
    return Future.value(true);
  });
}

// =========================================================================
// MAIN ENTRY POINT
// =========================================================================

void main() async { // Ubah jadi async karena ada inisialisasi awal
  // Menjamin framework Flutter sudah siap sebelum memanggil inisialisasi
  WidgetsFlutterBinding.ensureInitialized();
  
  // 3. Inisialisasi WorkManager (Memberikan ID Card ke Satpam)
  await Workmanager().initialize(
    callbackDispatcher, // Fungsi top-level di atas
    isInDebugMode: true, // true akan memunculkan log notifikasi di layar saat tugas berjalan
  );
  
  // WAJIB: Memanggil registrasi Dependency Injection
  setupLocator(); 
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengubah MaterialApp menjadi MaterialApp.router agar mendukung GoRouter
    return MaterialApp.router(
      // SEKARANG PITA DEBUG INI BISA DIKONTROL DARI TERMINAL / LAUNCH.JSON!
      debugShowCheckedModeBanner: EnvConfig.showDebugBanner,
      title: 'UTD Store Rafly',
      theme: AppTheme.lightTheme, // Memanggil tema global
      
      // Menghubungkan konfigurasi router yang kita buat di AppRouter
      routerConfig: AppRouter.router,
    );
  }
}