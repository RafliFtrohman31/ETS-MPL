import 'package:isar/isar.dart';

part 'bookmark_model.g.dart'; 

@collection
class Bookmark {
  Id id = Isar.autoIncrement; 
  
  late String productId;
  late String productName;
  late String productImage; // Tambahan: Agar halaman koleksi ada gambarnya
  late String timestamp;    // Wajib: Menampilkan jam & tanggal simpan WIB

  // Constructor kosong wajib untuk Isar
  Bookmark();

  // Helper untuk mempermudah update data secara immutable
  Bookmark copyWith({
    Id? id,
    String? productId,
    String? productName,
    String? productImage,
    String? timestamp,
  }) {
    return Bookmark()
      ..id = id ?? this.id
      ..productId = productId ?? this.productId
      ..productName = productName ?? this.productName
      ..productImage = productImage ?? this.productImage
      ..timestamp = timestamp ?? this.timestamp;
  }
}