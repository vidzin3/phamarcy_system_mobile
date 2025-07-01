import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/medicine.dart';

class AddMedicineScreen extends StatefulWidget {
  final Function(Medicine) onAdd;

  const AddMedicineScreen({super.key, required this.onAdd});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  String _selectedCategory = "Pain Relief";
  File? _pickedImage;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newMed = Medicine(
        name: _nameCtrl.text,
        price: double.tryParse(_priceCtrl.text) ?? 0.0,
        category: _selectedCategory,
        imageFile: _pickedImage,
      );
      widget.onAdd(newMed);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Medicine")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _pickedImage == null
                    ? Container(
                  height: 150,
                  color: Colors.grey.shade300,
                  child: const Center(child: Text("Tap to add image")),
                )
                    : Image.file(_pickedImage!, height: 150, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Medicine Name'),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: ["Pain Relief", "Supplements", "Cold & Flu"]
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => _selectedCategory = v!,
                decoration: const InputDecoration(labelText: "Category"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Add Medicine"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
