import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Information"),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: const Center(
        child: Text("About screen goes here "),
      ),
    );
  }
}