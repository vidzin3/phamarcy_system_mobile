import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:phamarcy_system/plugins/DatabaseHelpers.dart';
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
  final _codeCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  String? _selectedCategory;
  String? _selectedType;
  String? _selectedUnit;
  File? _pickedImage;
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _types = [];
  List<Map<String, dynamic>> _units = [];
  bool _isLoading = false;
  DateTime? _expiryDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    
    if (pickedDate != null) {
      setState(() => _expiryDate = pickedDate);
    }
  }

   @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchTypes();
    _fetchUnits();
  }

  Future<void> _fetchCategories() async {
    setState(() => _isLoading = true);
    
    try {
      final db = await DatabaseHelper().database;
      final results = await db.query('categories'); 
      
      setState(() {
        _categories = results;
        if (_categories.isNotEmpty) {
          _selectedCategory = _categories[0]['id'].toString();
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load categories: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchTypes() async {
    setState(() => _isLoading = true);
    
    try {
      final db = await DatabaseHelper().database;
      final results = await db.query('types'); 
      
      setState(() {
        _types = results;
        if (_types.isNotEmpty) {
          _selectedType = _types[0]['id'].toString();
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load types: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchUnits() async {
    setState(() => _isLoading = true);
    
    try {
      final db = await DatabaseHelper().database;
      final results = await db.query('units'); 
      
      setState(() {
        _units = results;
        if (_units.isNotEmpty) {
          _selectedUnit = _units[0]['id'].toString();
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Units: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {

      setState(() => _isLoading = true);
    
      try {
        final db = await DatabaseHelper().database;

        final result = await db.insert('medicines', {
          'name': _nameCtrl.text.toString(),
          'code': _codeCtrl.text.toString(),
          'expired_date': _expiryDate.toString(),
          'type': _selectedType,
          'category_id': _selectedCategory,
          'unit': _selectedUnit,
          'price': _priceCtrl.text.toString()
        });
        setState(() {
          if (result > 0) {
            _nameCtrl.text = "";
            _codeCtrl.text = "";
            _selectedCategory = _units[0]['id'].toString();
            _selectedType = _units[0]['id'].toString();
            _selectedUnit = _units[0]['id'].toString();
            _priceCtrl.text = "";

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Medicine saved successfully!')),
            );

            Navigator.pop(context);
          }
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Save: ${e.toString()}')),
        );
      }
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
                controller: _codeCtrl,
                decoration: const InputDecoration(labelText: 'Medicine Code'),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
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
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Expiry Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _expiryDate != null 
                            ? _dateFormat.format(_expiryDate!)
                            : 'Select expiry date',
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['id'].toString(),
                    child: Text(category['name'] ?? 'Unknown'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value.toString();
                  });
                },
                decoration: const InputDecoration(labelText: "Categorys"),
              ),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: _types.map((typs) {
                  return DropdownMenuItem<String>(
                    value: typs['id'].toString(),
                    child: Text(typs['name'] ?? 'Unknown'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value.toString();
                  });
                },
                decoration: const InputDecoration(labelText: "Types"),
              ),
              DropdownButtonFormField<String>(
                value: _selectedUnit,
                items: _units.map((unit) {
                  return DropdownMenuItem<String>(
                    value: unit['id'].toString(),
                    child: Text(unit['name'] ?? 'Unknown'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUnit = value.toString();
                  });
                },
                decoration: const InputDecoration(labelText: "Units"),
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
