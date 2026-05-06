import 'package:equatable/equatable.dart';
import '../../domain/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

// 1. Kondisi saat sedang memuat data[cite: 5]
class ProductLoading extends ProductState {}

// 2. Kondisi saat data berhasil didapat[cite: 5]
class ProductLoaded extends ProductState {
  final List<Product> products;
  const ProductLoaded(this.products);

  @override
  List<Object> get props => [products];
}

// 3. Kondisi saat terjadi error[cite: 5]
class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}