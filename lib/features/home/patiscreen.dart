import 'package:flutter/material.dart';

class Patiscreen extends StatefulWidget {
  const Patiscreen({super.key});

  @override
  State<Patiscreen> createState() => _PatiscreenState();
}

class _PatiscreenState extends State<Patiscreen> {
  List<Map<String, dynamic>> reports = [
    {
      'name': 'vid',
      'description': 'test',
      'status': true,
    },
    {
      'name': 'rafat',
      'description': 'test',
      'status': false,
    },
    {
      'name': 'smey',
      'description': 'test',
      'status': true,
    },
  ];

  void _toggleStatus(int index) {
    setState(() {
      reports[index]['status'] = !reports[index]['status'];
    });
  }

  void _addReport() async {
    final newReport = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddPatientPage()),
    );
    if (newReport != null) {
      setState(() {
        reports.add(newReport);
      });
    }
  }

  void _deleteReport(int index) {
    setState(() {
      reports.removeAt(index);
    });
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
      body: ListView.builder(
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
              title: Text(report['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(report['description']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isPaid ? Colors.green.shade100 : Colors.red.shade100,
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
                    onChanged: (value) {
                      _toggleStatus(index);
                    },
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
        child: const Icon(Icons.add,color: Colors.white,),
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
  String name = '';
  String description = '';
  bool isPaid = false;

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
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (val) => name = val ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (val) => description = val ?? '',
              ),
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
                onPressed: () {
                  _formKey.currentState?.save();
                  final newReport = {
                    'name': name,
                    'description': description,
                    'status': isPaid,
                  };
                  Navigator.pop(context, newReport);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
