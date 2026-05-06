class Product {
  final String id;
  final String name;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';
    
    // Penyesuaian format gambar agar fleksibel sesuai standar industri[cite: 4, 7]
    if (json['image'] != null) {
      imageUrl = json['image'].toString();
    } else if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      imageUrl = json['images'][0].toString();
      // Membersihkan karakter aneh jika data berasal dari API yang berbeda
      imageUrl = imageUrl.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '');
    }

    return Product(
      id: json['id'].toString(),
      // Sesuai standar Clean Architecture, data mentah dibiarkan murni di Model
      // Manipulasi label NIM dilakukan di level Repository/Service
      name: json['title'] ?? 'Tanpa Nama', 
      image: imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/150',
    );
  }

  // Method copyWith wajib ada untuk menerapkan logika NIM Genap di Repository
  Product copyWith({
    String? id,
    String? name,
    String? image,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }
}