import '../data/product_repository.dart';
import 'product_model.dart';

class ProductService {
  final ProductRepository repository;

  ProductService(this.repository);

  // Fungsi untuk mengambil daftar produk dengan logika delay personal
  Future<List<Product>> fetchProducts() async {
    // LOGIKA PERSONAL NIM RAFLI: 20123048 (Digit terakhir 8)
    // Sesuai instruksi ETS, aplikasi wajib delay selama X detik (Digit terakhir NIM).
    // Karena digit terakhir NIM Anda adalah 8, maka delay diatur selama 8 detik.
    await Future.delayed(const Duration(seconds: 8)); 

    return await repository.getAllProducts();
  }

  // Fungsi untuk mengambil detail produk tunggal
  Future<Product?> fetchProductDetail(String id) async {
    // Memanggil repository untuk mencari satu produk berdasarkan ID[cite: 6]
    return await repository.getProductById(id);
  }
}