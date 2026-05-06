import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../data/isar_service.dart';
import 'package:utd_advanced_app/features/bookmark/domain/bookmark_model.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isarService = locator<IsarService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Koleksi Bookmark Rafly')),
      body: StreamBuilder<List<Bookmark>>(
        stream: isarService.listenToBookmarks(), // Reactive Watch[cite: 2, 8]
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final bookmarks = snapshot.data!;
          
          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final b = bookmarks[index];
              return ListTile(
                title: Text(b.productName),
                subtitle: Text(b.timestamp), // Tampilkan Waktu Simpan[cite: 8]
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => isarService.deleteBookmark(b.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}