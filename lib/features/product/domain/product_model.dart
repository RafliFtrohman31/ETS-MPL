class Product {
  final String id;
  final String name;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.image,
  });

  // Untuk mengubah JSON dari API menjadi Objek Dart[cite: 4]
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['title'] ?? 'Tanpa Nama',
      image: json['image'] ?? '',
    );
  }

  // Fungsi pembantu untuk memanipulasi data (Logika NIM)
  Product copyWith({String? name}) {
    return Product(
      id: id,
      name: name ?? this.name,
      image: image,
    );
  }
}