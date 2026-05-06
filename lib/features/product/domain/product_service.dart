import '../data/product_repository.dart';
import 'product_model.dart';

class ProductService {
  final ProductRepository repository;
  ProductService(this.repository);

  Future<List<Product>> fetchProducts() async {
    return await repository.getAllProducts();
  }
  Future<void> splashDelay() async {
  await Future.delayed(const Duration(seconds: 8)); // Delay sesuai digit terakhir NIM
}
}