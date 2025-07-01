import 'package:flutter/material.dart';
import 'package:phamarcy_system/widgets/add_medicine_screen.dart';
import '../../../models/medicine.dart';
import '../../widgets/add_medicine_sheet.dart';
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
        final matchQuery =
        med.name.toLowerCase().contains(query.toLowerCase());
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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Medicines", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade600,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddMedicineScreen(
                onAdd: (newMed) {
                  setState(() {
                    allMedicines.add(newMed);
                    filterMedicines();
                  });
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final medicine = filtered[i];
                return Dismissible(
                  key: ValueKey(medicine.name),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    setState(() {
                      allMedicines.remove(medicine);
                      filterMedicines();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${medicine.name} deleted')),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: MedicineCard(medicine: medicine),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
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
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: DropdownButtonFormField<String>(
              value: selectedCategory ?? categories[0],
              decoration: InputDecoration(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) {
                selectedCategory = val;
                filterMedicines();
              },
            ),
          ),
        ],
      ),
    );
  }
}
