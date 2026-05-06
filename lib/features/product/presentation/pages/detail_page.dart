import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/di/injection.dart';
import 'package:utd_advanced_app/features/bookmark/data/isar_service.dart';
import '../../domain/product_service.dart';
import '../../domain/product_model.dart';
import 'package:utd_advanced_app/features/bookmark/domain/bookmark_model.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatelessWidget {
  final String productId;

  const DetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final productService = locator<ProductService>();
    final isarService = locator<IsarService>();

    const Color primaryColor = Color(0xFF008080); // Teal Kalem
    const Color secondaryColor = Color(0xFFE0F2F1); // Teal Muda
    const Color accentColor = Color(0xFFFFF4E5); // Soft Orange

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "RAFLI EXCLUSIVE",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.white, letterSpacing: 1.1),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<Product?>(
        future: productService.fetchProductDetail(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primaryColor));
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Gagal memuat detail produk"));
          }

          final product = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageSection(product, accentColor),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "NIM: 20123048",
                              style: TextStyle(color: primaryColor.withOpacity(0.6), fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.name,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Rp249.000", 
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: primaryColor),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              "DESKRIPSI PRODUK",
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 1.0, color: Colors.black54),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Koleksi eksklusif dari Rafly Store. Produk ini diproses melalui API publik dengan validasi kualitas tinggi.",
                              style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.6),
                            ),
                            const SizedBox(height: 30),
                            _buildInfoGrid(secondaryColor, primaryColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom Bar dengan Logika Fix LateInitializationError
              _buildBottomAction(context, isarService, product, primaryColor),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageSection(Product product, Color accentColor) {
    return Stack(
      children: [
        Container(
          height: 380,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFF9FBFB),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          padding: const EdgeInsets.all(30),
          child: Hero(
            tag: product.id,
            child: Image.network(product.image, fit: BoxFit.contain),
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "PROMO ONGKIR",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFFE67E22)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context, IsarService isarService, Product product, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            _buildShareButton(),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    // FIX: Inisialisasi semua field agar tidak LateInitializationError
                    final String currentTime = DateFormat('dd MMM, HH:mm').format(DateTime.now());

                    final newBookmark = Bookmark()
                      ..productId = product.id.toString()
                      ..productName = product.name
                      ..productImage = product.image // Diisi agar tidak error saat copyWith
                      ..timestamp = currentTime;

                    await isarService.saveBookmark(newBookmark);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tersimpan di Koleksi Rafly! ($currentTime)'),
                          backgroundColor: primaryColor,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "TAMBAH KE BOOKMARK",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: IconButton(
        icon: const Icon(Icons.share_outlined, color: Colors.black87),
        onPressed: () {},
      ),
    );
  }

  Widget _buildInfoGrid(Color secondaryColor, Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoCard(Icons.verified_user_outlined, "Original", secondaryColor, primaryColor),
        _infoCard(Icons.local_shipping_outlined, "Gratis Pos", secondaryColor, primaryColor),
        _infoCard(Icons.workspace_premium_outlined, "Best Seller", secondaryColor, primaryColor),
      ],
    );
  }

  Widget _infoCard(IconData icon, String title, Color bgColor, Color iconColor) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
        ],
      ),
    );
  }
}