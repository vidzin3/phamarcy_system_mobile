import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Dashscreen extends StatelessWidget {
  const Dashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        elevation: 2,
        titleSpacing: 8,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/lokkru.jpg'),
              backgroundColor: Colors.white,
              radius: 18,
            ),
            const SizedBox(width: 10),
            const Text(
              'Hi, Vid',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {
                  // Navigate to notifications page
                },
                icon: const Icon(Icons.notifications_none, color: Colors.white),
              ),
              Positioned(
                right: 10,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Center(
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryRow(),
            const SizedBox(height: 24),
            _buildSalesChart(),
            const SizedBox(height: 24),
            _buildNewsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoCard(
          title: 'Patients',
          value: '128',
          icon: Icons.people,
          color: Colors.green.shade400,
        ),
        _buildInfoCard(
          title: 'Medications',
          value: '58',
          icon: Icons.medical_services,
          color: Colors.blue.shade400,
        ),
        _buildInfoCard(
          title: 'Sales',
          value: '\$1.2K',
          icon: Icons.attach_money,
          color: Colors.orange.shade400,
        ),
      ],
    );
  }

  Widget _buildSalesChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Monthly Sales",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Container(
          height: 220,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: BarChart(
            BarChartData(
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                // bottomTitles: AxisTitles(
                //   sideTitles: SideTitles(
                //     showTitles: true,
                //     getTitlesWidget: (double value, TitleMeta meta) {
                //       const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];
                //       return SideTitleWidget(
                //         axisSide: meta.axisSide,
                //         child: Text(
                //           months[value.toInt()],
                //           style: const TextStyle(fontSize: 12),
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ),
              barGroups: List.generate(
                5,
                (i) => BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: (i + 1) * 3.0,
                      color: Colors.blue.shade400,
                      width: 16,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "News & Updates",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            _buildNewsCard(
              title: "New medicine shipment arrived",
              subtitle: "Check the latest stock updates",
              icon: Icons.local_shipping,
              color: Colors.teal,
            ),
            const SizedBox(height: 8),
            _buildNewsCard(
              title: "COVID-19 vaccines available",
              subtitle: "Schedule an appointment now",
              icon: Icons.local_hospital,
              color: Colors.blueAccent,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNewsCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: navigate to detail
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(title, style: TextStyle(color: Colors.black.withOpacity(0.6))),
          ],
        ),
      ),
    );
  }
}
