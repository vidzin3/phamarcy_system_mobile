import 'package:flutter/material.dart';

class Patiscreen extends StatefulWidget {
  const Patiscreen({super.key});

  @override
  State<Patiscreen> createState() => _PatiscreenState();
}

class _PatiscreenState extends State<Patiscreen> {
  // Simulated data list
  List<Map<String, dynamic>> reports = [
    {
      'name': 'vid',
      'description': 'test',
      'status': true, // true = Paid
    },
    {
      'name': 'rafat',
      'description': 'test',
      'status': false, // false = Unpaid
    },
    {
      'name': 'smey',
      'description': 'test',
      'status': true,
    },
  ];

  // Handle switch toggle
  void _toggleStatus(int index) {
    setState(() {
      reports[index]['status'] = !reports[index]['status'];
    });

    // TODO: Call API to update status in MySQL
    // e.g., await http.post('/update-status', body: {...})
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports', style: TextStyle(color: Colors.white)),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
