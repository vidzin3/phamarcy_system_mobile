class Medicine {
  final int? id;
  final String name;
  final String code;
  final String expiredDate;
  final String type;
  final int categoryId;
  final String unit;
  final double price;
  final String? imageUrl;
  final String? category;     // Optional, for display
  final String? imageFile;    // Optional, for local images

  Medicine({
    this.id,
    required this.name,
    required this.code,
    required this.expiredDate,
    required this.type,
    required this.categoryId,
    required this.unit,
    required this.price,
    this.imageUrl,
    this.category,
    this.imageFile,
  });

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      expiredDate: map['expired_date'],
      type: map['type'],
      categoryId: map['category_id'],
      unit: map['unit'],
      price: double.tryParse(map['price'].toString()) ?? 0.0,
      imageUrl: map['image_url'],   // only if exists
      category: map['category'],    // only if exists
      imageFile: map['image_file'], // only if exists
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'expired_date': expiredDate,
      'type': type,
      'category_id': categoryId,
      'unit': unit,
      'price': price.toString(),
      'image_url': imageUrl,
      'category': category,
      'image_file': imageFile,
    };
  }
}
