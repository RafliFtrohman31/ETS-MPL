import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/product/presentation/pages/product_page.dart';
import '../../features/product/presentation/cubit/product_cubit.dart';
import '../di/injection.dart';
import '../../features/crypto/presentation/pages/crypto_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          // Membungkus halaman dengan BlocProvider agar UI bisa dengar Cubit
          return BlocProvider(
            create: (context) => locator<ProductCubit>()..fetchAllProducts(),
            child: const ProductPage(),
          );
        },
      ),
      GoRoute(path: '/crypto', builder: (context, state) => const CryptoPage()),
    ],
  );
}
