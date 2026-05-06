import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/bookmark_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory(); // Folder HP
      return await Isar.open(
        [BookmarkSchema],
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  // CREATE: Simpan Bookmark dengan Timestamp[cite: 2, 8]
  Future<void> saveBookmark(Bookmark bookmark) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.bookmarks.putSync(bookmark));
  }

  // READ & REACTIVE: Pantau data secara real-time[cite: 2, 8]
  Stream<List<Bookmark>> listenToBookmarks() async* {
    final isar = await db;
    yield* isar.bookmarks.where().watch(fireImmediately: true);
  }

  // DELETE: Hapus Bookmark
  Future<void> deleteBookmark(Id id) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.bookmarks.deleteSync(id));
  }
}