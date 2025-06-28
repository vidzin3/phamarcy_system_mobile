import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';

class CartBottomSheet extends StatelessWidget {
  const CartBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Your Cart",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          if (cart.items.isEmpty) const Text("No items yet."),
          ...cart.items.map(
            (m) => ListTile(
              title: Text(m.name),
              subtitle: Text("\$${m.price.toStringAsFixed(2)}"),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: cart.items.isEmpty
                ? null
                : () {
                    // handle checkout
                    Navigator.pop(context);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text("Proceed to Checkout"),
          ),
        ],
      ),
    );
  }
}
