import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UTD Store Rafly')),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          // 1. Kondisi Loading[cite: 5]
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // 2. Kondisi Error[cite: 5]
          if (state is ProductError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }

          // 3. Kondisi Sukses (Menampilkan List Produk + Logika NIM)[cite: 5, 8]
          if (state is ProductLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final item = state.products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.network(item.image, width: 50, errorBuilder: (c, e, s) => const Icon(Icons.error)),
                    title: Text(item.name), // Nama sudah mengandung "[Promo Ongkir]"
                    subtitle: Text('ID: ${item.id}'),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}