import 'package:flutter/material.dart';
import 'package:phamarcy_system/plugins/DatabaseHelpers.dart';
import 'package:phamarcy_system/widgets/add_medicine_screen.dart';

class Mediscreen extends StatefulWidget {
  const Mediscreen({super.key});

  @override
  State<Mediscreen> createState() => _MediscreenState();
}

class _MediscreenState extends State<Mediscreen> {
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _medicines = [];
  String? _selectedCategory;
  String _searchQuery = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    setState(() => _isLoading = true);
    await _fetchCategories();
    await _fetchMedicines();
    setState(() => _isLoading = false);
  }

  Future<void> _fetchCategories() async {
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
      _showError('Failed to load categories: $e');
    }
  }

  Future<void> _fetchMedicines() async {
    try {
      final db = await DatabaseHelper().database;
      final whereClause = _selectedCategory != null ? 'WHERE m.category_id = ?' : '';
      final whereArgs = _selectedCategory != null ? [_selectedCategory] : [];
      final query = '''
        SELECT m.*, 
               c.name AS category_name, 
               u.name AS unit_name, 
               t.name AS type_name 
        FROM medicines m 
        LEFT JOIN categories c ON m.category_id = c.id 
        LEFT JOIN units u ON m.unit = u.id 
        LEFT JOIN types t ON m.type = t.id
        $whereClause
      ''';
      final results = await db.rawQuery(query, whereArgs);

      setState(() {
        _medicines = results.where((medicine) =>
          medicine['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())
        ).toList();
      });
    } catch (e) {
      _showError('Failed to load medicines: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _updateMedicine(Map<String, dynamic> medicine) async {
    final TextEditingController nameCtrl = TextEditingController(text: medicine['name']);
    final TextEditingController priceCtrl = TextEditingController(text: medicine['price'].toString());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Medicine'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final db = await DatabaseHelper().database;
              await db.update(
                'medicines',
                {
                  'name': nameCtrl.text,
                  'price': double.tryParse(priceCtrl.text) ?? 0.0,
                },
                where: 'id = ?',
                whereArgs: [medicine['id']],
              );
              Navigator.pop(context);
              await _fetchMedicines();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
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
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddMedicineScreen(
                onAdd: (newMed) {
                  setState(() {
                  });
                },
              ),
            ),
          );
          // await Navigator.pushNamed(context, '/add_medicine');
          await _fetchMedicines();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _medicines.length,
                  itemBuilder: (_, i) {
                    final medicine = _medicines[i];
                    return Dismissible(
                      key: ValueKey(medicine['id']),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) async {
                        final db = await DatabaseHelper().database;
                        await db.delete(
                          'medicines',
                          where: 'id = ?',
                          whereArgs: [medicine['id']],
                        );
                        await _fetchMedicines();
                        _showError('${medicine['name']} deleted');
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
                      child: GestureDetector(
                        onTap: () => _updateMedicine(medicine),
                        child: Card(
                          child: ListTile(
                            title: Text('${medicine['code']} - ${medicine['name']}' ?? 'No Name'),
                            subtitle: Text(medicine['category_name'] ?? 'No Category'),
                            trailing: Text("${medicine['price']}៛"),
                          ),
                        ),
                      ),
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
                  setState(() {
                    _searchQuery = val;
                  });
                  _fetchMedicines();
                },
                decoration: InputDecoration(
                  hintText: "Search medicine",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
              value: _selectedCategory,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category['id'].toString(),
                  child: Text(category['name'] ?? 'Unknown'),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedCategory = val;
                });
                _fetchMedicines();
              },
            ),
          ),
        ],
      ),
    );
  }
}
