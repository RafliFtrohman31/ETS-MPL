import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_state.dart';
import '../../domain/product_service.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductService _service;

  ProductCubit(this._service) : super(ProductLoading());

  Future<void> fetchAllProducts() async {
    emit(ProductLoading()); // Pasang indikator loading[cite: 5]
    try {
      final data = await _service.fetchProducts(); // Panggil data dari Service[cite: 5]
      emit(ProductLoaded(data)); // Berhasil! Tampilkan data[cite: 5]
    } catch (e) {
      emit(ProductError('Gagal memuat produk: $e')); // Gagal! Tampilkan error[cite: 5]
    }
  }
}