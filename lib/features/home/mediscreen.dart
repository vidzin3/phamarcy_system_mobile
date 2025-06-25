import 'package:flutter/material.dart';

class Mediscreen extends StatelessWidget {
  const Mediscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicines', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1976D2),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('this is medicine screen xD')],
        ),
      ),
    );
  }
}
