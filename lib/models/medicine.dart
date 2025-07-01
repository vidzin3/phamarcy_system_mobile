import 'dart:io';

class Medicine {
  String name;
  double price;
  String category;
  String? imageUrl; // For online image
  File? imageFile;  // For local image

  Medicine({
    required this.name,
    required this.price,
    required this.category,
    this.imageUrl,
    this.imageFile,
  });
}