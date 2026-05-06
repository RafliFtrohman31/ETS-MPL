import 'package:isar/isar.dart';

part 'bookmark_model.g.dart'; // Nama file gaib Isar

@collection
class Bookmark {
  Id id = Isar.autoIncrement; // ID otomatis urut
  
  late String productId;
  late String productName;
  late String timestamp; // Wajib untuk Syarat ETS
}