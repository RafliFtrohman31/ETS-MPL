import 'package:dio/dio.dart';
import '../domain/product_model.dart';
import '../../../../core/di/injection.dart'; 
import '../../../../core/network/api_client.dart'; 

class ProductRepository {
  // Mengambil instance ApiClient melalui Dependency Injection (Get_it)[cite: 4, 6]
  final ApiClient _apiClient = locator<ApiClient>();

  // Fungsi untuk mengambil seluruh daftar produk dari API
  Future<List<Product>> getAllProducts() async {
    try {
      // Mengakses endpoint /products menggunakan Dio[cite: 4]
      final response = await _apiClient.dio.get('/products');
      
      final List<dynamic> jsonList = response.data;
      
      return jsonList.map((json) {
        final product = Product.fromJson(json);

        // LOGIKA PERSONAL NIM RAFLI: 20123048 (Digit terakhir 8 - Genap)
        // Wajib menambahkan label [Promo Ongkir] di level repository sesuai instruksi ETS[cite: 8]
        return product.copyWith(
          name: "${product.name} [Promo Ongkir]",
        );
      }).toList();
    } on DioException catch (e) {
      // Menangkap error spesifik dari library Dio[cite: 4]
      throw Exception('Gagal memuat jaringan: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan sistem: $e');
    }
  }

  // Fungsi untuk mengambil detail satu produk berdasarkan ID[cite: 4]
  Future<Product?> getProductById(String id) async {
    try {
      final response = await _apiClient.dio.get('/products/$id');
      final product = Product.fromJson(response.data);

      // LOGIKA PERSONAL: Tetap gunakan label yang sama agar data konsisten di halaman detail[cite: 8]
      return product.copyWith(
        name: "${product.name} [Promo Ongkir]",
      );
    } catch (e) {
      // Mengembalikan null jika produk tidak ditemukan atau terjadi gangguan[cite: 4]
      return null;
    }
  }
}