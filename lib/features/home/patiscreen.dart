import 'package:flutter/material.dart';

class Patiscreen extends StatelessWidget {
  const Patiscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1976D2),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('this is pati screen Xd')],
        ),
      ),
    );
  }
}
