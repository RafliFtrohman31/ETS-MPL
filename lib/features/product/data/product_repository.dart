import '../domain/product_model.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';

class ProductRepository {
  // Mengambil ApiClient (Dio) dari locator
  final ApiClient _apiClient = locator<ApiClient>();

  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _apiClient.dio.get('/products');
      final List<dynamic> jsonList = response.data;

      // Mapping data sekaligus menerapkan Logika NIM Genap[cite: 8]
      return jsonList.map((json) {
        final product = Product.fromJson(json);
        
        // Logika Personal NIM Genap: Tambahkan [Promo Ongkir][cite: 8]
        return product.copyWith(name: "${product.name} [Promo Ongkir]");
      }).toList();
      
    } catch (e) {
      throw Exception('Gagal mengambil data produk: $e');
    }
  }
}