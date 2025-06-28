import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/medicine.dart';
import '../provider/cart_provider.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  const MedicineCard({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            medicine.imageUrl,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(medicine.name),
        subtitle: Text(
          "${medicine.category}\n\$${medicine.price.toStringAsFixed(2)}",
        ),
        isThreeLine: true,
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => cart.addToCart(medicine),
          child: const Text("Add"),
        ),
      ),
    );
  }
}
