import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phamarcy_system/plugins/DatabaseHelpers.dart';
import 'package:multiselect/multiselect.dart';
class Patiscreen extends StatefulWidget {
  const Patiscreen({super.key});

  @override
  State<Patiscreen> createState() => _PatiscreenState();
}

class _PatiscreenState extends State<Patiscreen> {
  List<Map<String, dynamic>> reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    setState(() => _isLoading = true);
    try {
      final db = await DatabaseHelper().database;
      final results = await db.query('patients');
      setState(() {
        reports = results.map((row) => {
          'id': row['id'],
          'name': row['name'],
          'description': row['description'],
          'status': row['is_paid'] == 1,
          'medicines': row['medicine_list'],
          'amount': row['amount'],
          'buy_date': row['buy_date'],
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load patients: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleStatus(int index) async {
    final newStatus = !reports[index]['status'];
    try {
      final db = await DatabaseHelper().database;
      await db.update(
        'patients',
        {'is_paid': newStatus ? 1 : 0},
        where: 'id = ?',
        whereArgs: [reports[index]['id']],
      );
      setState(() {
        reports[index]['status'] = newStatus;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }

  Future<void> _deleteReport(int index) async {
    final id = reports[index]['id'];
    try {
      final db = await DatabaseHelper().database;
      await db.delete(
        'patients',
        where: 'id = ?',
        whereArgs: [id],
      );
      setState(() {
        reports.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Patient deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete patient: $e')),
      );
    }
  }

  Future<void> _addReport() async {
    final newReport = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddPatientPage()),
    );
    if (newReport != null) {
      await _fetchPatients(); // Refresh the list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : reports.isEmpty
              ? const Center(child: Text('No patients found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    final isPaid = report['status'];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(Icons.person, color: Colors.blue),
                        ),
                        title: Text(report['name'], 
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(report['description']),
                            Text('Amount: \$${report['amount']}'),
                            Text('Medicines: ${report['medicines']}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: isPaid 
                                    ? Colors.green.shade100 
                                    : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isPaid ? 'Paid' : 'Unpaid',
                                style: TextStyle(
                                  color: isPaid ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Switch(
                              value: isPaid,
                              activeColor: Colors.green,
                              inactiveThumbColor: Colors.red,
                              onChanged: (value) => _toggleStatus(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteReport(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReport,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _phonenumber = TextEditingController();
  final _description = TextEditingController();
  final _amount = TextEditingController();
  final _medicine_list = TextEditingController();
  bool isPaid = false;
  bool _isLoading = false;

  List<String> _selectedMedicine = [];
  List<Map<String, dynamic>> medicines = [];

  DateTime? _buyDate;
  DateTime? _paidDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> _pickBuyDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    
    if (pickedDate != null) {
      setState(() => _buyDate = pickedDate);
    }
  }

  Future<void> _pickPaidDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    
    if (pickedDate != null) {
      setState(() => _paidDate = pickedDate);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  Future<void> _fetchMedicines() async {
    setState(() => _isLoading = true);
    
    try {
      final db = await DatabaseHelper().database;
      final results = await db.query('medicines'); 
      
      setState(() {
        medicines = results;
        // if (medicines.isNotEmpty) {
        //   _selectedMedicine = medicines[0]['id'].toString();
        // }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load medicines: ${e.toString()}')),
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

        final result = await db.insert('patients', {
          'name': _name.text.toString(),
          'age': _age.text.toString(),
          'phone_number': _phonenumber.text.toString(),
          'description': _description.text.toString(),
          'medicine_list': _medicine_list.text.toString(),
          'amount': _amount.text.toString(),
          'buy_date': _buyDate.toString(),
          'is_paid': isPaid
        });

        setState(() {
          if (result > 0) {
            // _nameCtrl.text = "";
            // _codeCtrl.text = "";
            // _selectedCategory = _units[0]['id'].toString();
            // _selectedType = _units[0]['id'].toString();
            // _selectedUnit = _units[0]['id'].toString();
            // _priceCtrl.text = "";

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Patient saved successfully!')),
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
      appBar: AppBar(title: const Text('Add Patient')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _age,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phonenumber,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              DropDownMultiSelect(
                onChanged: (List<String> selectedNames) {
                  setState(() {
                    _selectedMedicine = selectedNames;
                    _medicine_list.text = jsonEncode(selectedNames); 
                  });
                },
                options: medicines
                    .map((medicine) => medicine['name']?.toString() ?? 'Unknown')
                    .toList(),
                selectedValues: _selectedMedicine,
                decoration: InputDecoration(
                  labelText: 'Medicines',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickBuyDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Buy Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _buyDate != null 
                            ? _dateFormat.format(_buyDate!)
                            : 'Select Buy date',
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amount,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Paid Status'),
                  Switch(
                    value: isPaid,
                    onChanged: (val) => setState(() => isPaid = val),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submit(),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
