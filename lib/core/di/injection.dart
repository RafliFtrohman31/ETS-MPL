import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../../features/product/data/product_repository.dart';
import '../../features/product/domain/product_service.dart';

// Inisialisasi sang 'Pelayan' (Injector) secara global
final locator = GetIt.instance;

void setupLocator() {
  // 1. DAFTARKAN API CLIENT (Modul 4 - Networking)
  // registerLazySingleton: Objek cuma dibuat 1x dan dipakai selamanya[cite: 4, 6]
  locator.registerLazySingleton<ApiClient>(() => ApiClient());

  // 2. DAFTARKAN REPOSITORY (Modul 2 - Data Layer)
  // Repository bertugas mengambil data murni dari internet lewat ApiClient[cite: 6, 7]
  locator.registerLazySingleton<ProductRepository>(() => ProductRepository());

  // 3. DAFTARKAN SERVICE (Modul 2 - Domain Layer)
  // registerFactory: Setiap kali dipanggil, Get_it akan memberikan instance baru.
  // Perhatikan locator(): Get_it otomatis mencari ProductRepository yang sudah terdaftar di atas.
  locator.registerFactory<ProductService>(() => ProductService(locator()));
}