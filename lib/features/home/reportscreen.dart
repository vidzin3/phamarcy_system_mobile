// A fully designed report screen with detailed view and add form
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Reportscreen extends StatefulWidget {
  const Reportscreen({super.key});

  @override
  State<Reportscreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<Reportscreen> {
  DateTime? fromDate;
  DateTime? toDate;
  String selectedType = 'All';

  final List<String> reportTypes = ['All', 'Sales', 'Expenses', 'Inventory'];

  List<Map<String, dynamic>> allReports = [];

  Future<void> selectDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  List<Map<String, dynamic>> get filteredReports => allReports.where((report) {
    final matchesType = selectedType == 'All' || report['type'] == selectedType;
    final date = report['date'] as DateTime;
    final matchesFrom = fromDate == null || !date.isBefore(fromDate!);
    final matchesTo = toDate == null || !date.isAfter(toDate!);
    return matchesType && matchesFrom && matchesTo;
  }).toList();

  void _viewReport(Map<String, dynamic> report) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportDetailPage(
          report: report,
          onDelete: () {
            setState(() {
              allReports.removeWhere((r) => r['id'] == report['id']);
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _addReport() async {
    final newReport = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddReportPage()),
    );
    if (newReport != null) {
      setState(() {
        allReports.add(newReport);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => selectDate(isFrom: true),
                          child: _dateInput(fromDate, 'From Date'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => selectDate(isFrom: false),
                          child: _dateInput(toDate, 'To Date'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedType,
                      underline: const SizedBox(),
                      onChanged: (val) => setState(() => selectedType = val!),
                      items: reportTypes
                          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredReports.isEmpty
                  ? const Center(child: Text("No matching reports"))
                  : ListView.builder(
                itemCount: filteredReports.length,
                itemBuilder: (context, index) {
                  final report = filteredReports[index];
                  return GestureDetector(
                    onTap: () => _viewReport(report),
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: const Icon(Icons.description, color: Colors.blue),
                        title: Text(report['title']),
                        subtitle: Text(
                            '${report['type']} | ${dateFormatter.format(report['date'])}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReport,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }

  Widget _dateInput(DateTime? date, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 18),
          const SizedBox(width: 8),
          Text(
            date != null ? DateFormat('yyyy-MM-dd').format(date) : label,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class AddReportPage extends StatefulWidget {
  const AddReportPage({super.key});

  @override
  State<AddReportPage> createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String details = '';
  String type = 'Sales';
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Report')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (val) => title = val ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Details'),
                onSaved: (val) => details = val ?? '',
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Type'),
                value: type,
                items: ['Sales', 'Expenses', 'Inventory']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => type = val!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState?.save();
                  final newReport = {
                    'id': DateTime.now().millisecondsSinceEpoch,
                    'title': title,
                    'details': details,
                    'type': type,
                    'date': date,
                  };
                  Navigator.pop(context, newReport);
                },
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ReportDetailPage extends StatelessWidget {
  final Map<String, dynamic> report;
  final VoidCallback onDelete;

  const ReportDetailPage({super.key, required this.report, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              onDelete();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${report['title']}', style: const TextStyle(fontSize: 18)),
            Text('Type: ${report['type']}'),
            Text('Date: ${dateFormatter.format(report['date'])}'),
            const SizedBox(height: 10),
            Text('Details: ${report['details']}'),
          ],
        ),
      ),
    );
  }
}
