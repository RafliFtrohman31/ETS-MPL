import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import Halaman Fitur
import '../../features/product/presentation/pages/splash_page.dart';
import '../../features/product/presentation/pages/product_page.dart';
import '../../features/product/presentation/pages/detail_page.dart';
import 'package:utd_advanced_app/features/crypto/presentation/pages/crypto_page.dart';
import '../../features/native/presentation/pages/native_page.dart';
import '../../features/bookmark/presentation/pages/bookmark_page.dart'; 
import '../../features/sync/presentation/pages/background_sync_page.dart'; // TAMBAHAN MODUL 9 [cite: 225]
import '../../features/animation/presentation/pages/animation_page.dart'; // TAMBAHAN MODUL 10 [cite: 885]

// Import State Management & DI
import '../../features/product/presentation/cubit/product_cubit.dart';
import '../di/injection.dart';

class AppRouter {
  static final router = GoRouter(
    // LOGIKA NIM RAFLI: Mulai dari Splash Screen (Delay 8 detik sesuai NIM 20123048)
    initialLocation: '/splash',

    routes: [
      // 1. Splash Screen
      GoRoute(
        path: '/splash', 
        builder: (context, state) => const SplashPage(),
      ),

      // 2. Katalog Produk (Home)
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (context) => locator<ProductCubit>()..fetchAllProducts(),
          child: const ProductPage(),
        ),
      ),

      // 3. Detail Produk (Modul 4 & 6)
      GoRoute(
        path: '/detail/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DetailPage(productId: id);
        },
      ),

      // 4. Monitoring Crypto (WebSocket & Isolate - Modul 5)
      GoRoute(
        path: '/crypto', 
        builder: (context, state) => const CryptoPage(),
      ),

      // 5. Integrasi Native (Battery & Toast - Modul 7)
      GoRoute(
        path: '/native', 
        builder: (context, state) => const NativePage(),
      ),

      // 6. Bookmark (Isar Database - Modul 6)
      GoRoute(
        path: '/bookmarks', 
        builder: (context, state) => const BookmarkPage(),
      ),

      // 7. Background Processing Settings (WorkManager - Modul 9) [cite: 227]
      GoRoute(
        path: '/sync', 
        builder: (context, state) => const BackgroundSyncPage(),
      ),

      // 8. Advanced Animations & Lottie (Modul 10) [cite: 662, 663, 887]
      // TAMBAHAN MODUL 10 [cite: 887]
      GoRoute(
        path: '/animation',
        builder: (context, state) => const AnimationPage(), 
      ),
    ],

    // Error Handling Page
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Error 404'),
        backgroundColor: const Color(0xFF008080), // Teal Kalem
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.find_in_page_rounded, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text('Halaman tidak ditemukan untuk NIM 20123048!', 
              style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    ),
  );
}