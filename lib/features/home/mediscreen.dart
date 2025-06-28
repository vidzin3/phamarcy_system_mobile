import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/medicine.dart';
import '../../provider/cart_provider.dart';
import '../../widgets/add_medicine_sheet.dart';
import '../../widgets/cart_bottom_sheet.dart';
import '../../widgets/medicine_cart.dart';

class Mediscreen extends StatefulWidget {
  const Mediscreen({super.key});

  @override
  State<Mediscreen> createState() => _MediscreenState();
}

class _MediscreenState extends State<Mediscreen> {
  final List<Medicine> allMedicines = [
    Medicine(
      name: "Paracetamol",
      price: 2.50,
      category: "Pain Relief",
      imageUrl:
          "https://img.freepik.com/free-photo/white-pills-white-background_23-2147879387.jpg",
    ),
    Medicine(
      name: "Vitamin C",
      price: 1.99,
      category: "Supplements",
      imageUrl:
          "https://img.freepik.com/free-photo/orange-vitamin-tablets-close-up_23-2148227207.jpg",
    ),
    Medicine(
      name: "Cough Syrup",
      price: 5.50,
      category: "Cold & Flu",
      imageUrl:
          "https://img.freepik.com/free-photo/cough-syrup-bottle_53876-144799.jpg",
    ),
  ];

  List<Medicine> filtered = [];
  String query = "";
  String? selectedCategory;
  final categories = ["All", "Pain Relief", "Supplements", "Cold & Flu"];

  @override
  void initState() {
    super.initState();
    filtered = List.from(allMedicines);
  }

  void filterMedicines() {
    setState(() {
      filtered = allMedicines.where((med) {
        final matchQuery = med.name.toLowerCase().contains(query.toLowerCase());
        final matchCategory =
            selectedCategory == null || selectedCategory == "All"
            ? true
            : med.category == selectedCategory;
        return matchQuery && matchCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>().items;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Medicines", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade600,
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (_) => const CartBottomSheet(),
                ),
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 9,
                    child: Text(
                      '${cart.length}',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => AddMedicineSheet(
              onMedicineAdded: (newMed) {
                setState(() {
                  allMedicines.add(newMed);
                  filterMedicines();
                });
              },
            ),
          );
        },
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              itemBuilder: (_, i) => MedicineCard(medicine: filtered[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (val) {
                query = val;
                filterMedicines();
              },
              decoration: InputDecoration(
                hintText: "Search medicine",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: selectedCategory ?? categories[0],
            items: categories
                .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                .toList(),
            onChanged: (val) {
              selectedCategory = val;
              filterMedicines();
            },
          ),
        ],
      ),
    );
  }
}
