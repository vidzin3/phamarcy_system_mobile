import 'package:flutter/material.dart';
import '../home/main_layout.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    // After 2 seconds, navigate to WelcomePage
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainLayout()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1976D2), // Customize background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/pharmacy_logo.png',
              width: 150,
              height: 155,
            ),
            const SizedBox(height: 10),
            Text(
              'Pharmacy App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans-Regular',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
