import 'package:flutter/material.dart';

class Reportscreen extends StatelessWidget {
  const Reportscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1976D2),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('this is report screen')],
        ),
      ),
    );
  }
}
