// import 'package:flutter/material.dart';
// import '../../../../models/medicine.dart';

// class AddMedicineSheet extends StatefulWidget {
//   final Function(Medicine) onMedicineAdded;
//   const AddMedicineSheet({super.key, required this.onMedicineAdded});

//   @override
//   State<AddMedicineSheet> createState() => _AddMedicineSheetState();
// }

// class _AddMedicineSheetState extends State<AddMedicineSheet> {
//   final nameCtrl = TextEditingController();
//   final priceCtrl = TextEditingController();
//   String? category;
//   final imageUrl =
//       "https://img.freepik.com/free-photo/medicine-pills.jpg"; // Placeholder

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(
//         16,
//         16,
//         16,
//         MediaQuery.of(context).viewInsets.bottom + 16,
//       ),
//       child: Wrap(
//         children: [
//           Center(
//             child: Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade400,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           const Text(
//             "Add Medicine",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 12),
//           TextField(
//             controller: nameCtrl,
//             decoration: const InputDecoration(labelText: "Name"),
//           ),
//           const SizedBox(height: 8),
//           TextField(
//             controller: priceCtrl,
//             keyboardType: TextInputType.number,
//             decoration: const InputDecoration(labelText: "Price"),
//           ),
//           const SizedBox(height: 8),
//           DropdownButtonFormField<String>(
//             hint: const Text("Select Category"),
//             items: [
//               "Pain Relief",
//               "Supplements",
//               "Cold & Flu",
//             ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
//             onChanged: (val) => category = val,
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue.shade600,
//               minimumSize: const Size(double.infinity, 48),
//             ),
//             onPressed: () {
//               if (nameCtrl.text.isEmpty ||
//                   priceCtrl.text.isEmpty ||
//                   category == null)
//                 return;
//               widget.onMedicineAdded(
//                 Medicine(
//                   name: nameCtrl.text,
//                   price: double.tryParse(priceCtrl.text) ?? 0.0,
//                   category: category!,
//                   imageUrl: imageUrl,
//                 ),
//               );
//               Navigator.pop(context);
//             },
//             child: const Text("Add"),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class AddMedicineSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onMedicineAdded; // ✅ accept map
  const AddMedicineSheet({super.key, required this.onMedicineAdded});

  @override
  State<AddMedicineSheet> createState() => _AddMedicineSheetState();
}

class _AddMedicineSheetState extends State<AddMedicineSheet> {
  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  String? category;
  final imageUrl =
      "https://img.freepik.com/free-photo/medicine-pills.jpg"; // Placeholder

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Wrap(
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Add Medicine",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: "Name"),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: priceCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Price"),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            hint: const Text("Select Category"),
            items: [
              "Pain Relief",
              "Supplements",
              "Cold & Flu",
            ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (val) => setState(() => category = val),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () {
              if (nameCtrl.text.isEmpty ||
                  priceCtrl.text.isEmpty ||
                  category == null) return;

              final newMed = {
                'name': nameCtrl.text,
                'price': double.tryParse(priceCtrl.text) ?? 0.0,
                'category': category,
                'imageUrl': imageUrl,
              };

              widget.onMedicineAdded(newMed); // ✅ send map back
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
