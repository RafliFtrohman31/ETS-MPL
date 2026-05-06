import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:utd_advanced_app/features/product/presentation/cubit/product_cubit.dart';
import 'package:utd_advanced_app/features/product/presentation/cubit/product_state.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Palet Warna Soft Teal & White (Cerah & Kalem)
    const Color primaryColor = Color(0xFF008080); 
    const Color secondaryColor = Color(0xFFE0F2F1); 
    const Color backgroundColor = Color(0xFFF9FBFB); 

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'RAFLI STORE', // Identitas Rafly[cite: 8]
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        actions: [
          // Tombol menuju halaman Bookmark (Modul 6 - Isar)[cite: 2, 8]
          IconButton(
            icon: const Icon(Icons.bookmarks_outlined, color: Colors.white),
            tooltip: 'Koleksi Bookmark',
            onPressed: () => context.push('/bookmarks'), 
          ),
          // Tombol menuju halaman Native (Modul 7 - Platform Channels)[cite: 1, 8]
          IconButton(
            icon: const Icon(Icons.settings_suggest_outlined, color: Colors.white),
            tooltip: 'Fitur Native',
            onPressed: () => context.push('/native'),
          ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          // 1. Tampilan Loading[cite: 5]
          if (state is ProductLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: primaryColor),
                  const SizedBox(height: 24),
                  Text(
                    'MENYIAPKAN KOLEKSI RAFLI...',
                    style: TextStyle(
                      color: primaryColor.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }

          // 2. Tampilan Sukses (Katalog Produk)[cite: 5, 8]
          if (state is ProductLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              itemCount: state.products.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = state.products[index];
                return GestureDetector(
                  onTap: () => context.push('/detail/${item.id}'), // Navigasi Detail
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              item.image,
                              width: 70,
                              height: 70,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported_rounded, color: primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name, // Sudah mengandung "[Promo Ongkir]" dari Repository[cite: 8]
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'NIM: 20123048 • ID: ${item.id}', // Logika Personal Rafly[cite: 8]
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Badge Promo Kalem sesuai Syarat NIM Genap[cite: 8]
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF4E5), 
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "PROMO ONGKIR", 
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFE67E22),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          // 3. Tampilan Error[cite: 5]
          if (state is ProductError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: Colors.red)),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      // Floating Action Button (Modul 5 - Crypto Hub)[cite: 3, 8]
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/crypto'),
        label: const Text(
          'CRYPTO HUB',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        icon: const Icon(Icons.auto_graph_rounded, color: Colors.white),
        backgroundColor: primaryColor,
        elevation: 4,
      ),
    );
  }
}