// import 'package:fl_chart/fl_chart.dart';
// import 'package:phamarcy_system/widgets/presentation/samples/chart_samples.dart';
import 'package:flutter/material.dart';

class Dashscreen extends StatelessWidget {
  const Dashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('this is dashboard body'),
            const SizedBox(height: 16),
            // Expanded(
            //   // child: Bar(), // 👈 use the chart widget
            // ),
          ],
        ),
      ),
    );
  }
}
