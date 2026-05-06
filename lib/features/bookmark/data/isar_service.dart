import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart'; // Tambahkan package intl di pubspec.yaml
import '../domain/bookmark_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory(); 
      return await Isar.open(
        [BookmarkSchema],
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  // CREATE: Simpan Bookmark dengan Detail Gambar & Jam (WIB)
  Future<void> saveBookmark(Bookmark bookmark) async {
    final isar = await db;
    
    // Menghasilkan waktu presisi saat tombol ditekan
    final String timeNow = DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());

    // Pastikan data yang disimpan lengkap sesuai permintaan Rafly
    final newBookmark = bookmark.copyWith(
      timestamp: timeNow, // Menambahkan jam dan tanggal otomatis
    );

    isar.writeTxnSync(() => isar.bookmarks.putSync(newBookmark));
  }

  // READ & REACTIVE: Pantau data secara real-time untuk UI
  Stream<List<Bookmark>> listenToBookmarks() async* {
    final isar = await db;
    // Mengawasi perubahan database secara reaktif
    yield* isar.bookmarks.where().watch(fireImmediately: true);
  }

  // DELETE: Hapus Bookmark berdasarkan ID
  Future<void> deleteBookmark(Id id) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.bookmarks.deleteSync(id));
  }
}