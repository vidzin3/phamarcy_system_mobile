import 'package:flutter/material.dart';
import '../../models/medicine.dart';

class CartProvider with ChangeNotifier {
  final List<Medicine> _items = [];

  List<Medicine> get items => _items;

  void addToCart(Medicine medicine) {
    _items.add(medicine);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int get itemCount => _items.length;
}
