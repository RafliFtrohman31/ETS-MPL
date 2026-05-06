import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../data/isar_service.dart';
import 'package:utd_advanced_app/features/bookmark/domain/bookmark_model.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isarService = locator<IsarService>();

    // Palet Warna: Soft Teal & Mint (Cerah & Kalem)
    const Color primaryColor = Color(0xFF008080); // Teal Utama
    const Color secondaryColor = Color(0xFFE0F2F1); // Teal Muda untuk Aksen
    const Color backgroundColor = Color(0xFFF5F7F7); // Putih bersih kebiruan

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'KOLEKSI RAFLY',
          style: TextStyle(
            fontWeight: FontWeight.w900, 
            fontSize: 18, 
            color: Colors.white, 
            letterSpacing: 1.5
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body: StreamBuilder<List<Bookmark>>(
        stream: isarService.listenToBookmarks(), // Reactive Watch Isar
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primaryColor));
          }

          final bookmarks = snapshot.data ?? [];

          // TAMPILAN JIKA KOSONG (EMPTY STATE)
          if (bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: .05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.bookmark_add_outlined, size: 70, color: primaryColor.withValues(alpha: .4)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'BELUM ADA KOLEKSI',
                    style: TextStyle(
                      color: primaryColor.withValues(alpha:  0.5), 
                      fontWeight: FontWeight.w900, 
                      letterSpacing: 2
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final b = bookmarks[index];
              return _buildBookmarkCard(context, b, isarService, primaryColor, secondaryColor);
            },
          );
        },
      ),
    );
  }

  // WIDGET KARTU BOOKMARK MODERN
  Widget _buildBookmarkCard(BuildContext context, Bookmark b, IsarService service, Color primary, Color secondary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: .05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // AREA GAMBAR PRODUK
              Container(
                width: 100,
                color: secondary,
                child: Image.network(
                  b.productImage, // Pastikan field ini ada di model Isar Anda
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                    Icon(Icons.broken_image_outlined, color: primary.withValues(alpha: 0.3)),
                ),
              ),
              // AREA DETAIL TEKS
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        b.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800, 
                          fontSize: 15, 
                          color: Colors.black87
                        ),
                      ),
                      const SizedBox(height: 8),
                      // INFORMASI JAM & TANGGAL (DETAIL KECIL)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: secondary.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.watch_later_outlined, size: 12, color: primary),
                            const SizedBox(width: 6),
                            Text(
                              'WIB: ${b.timestamp}', 
                              style: TextStyle(
                                fontSize: 10, 
                                color: primary, 
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // TOMBOL HAPUS DENGAN FEEDBACK
                      Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () {
                            service.deleteBookmark(b.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${b.productName} dihapus'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded, 
                              color: Colors.redAccent, 
                              size: 20
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}