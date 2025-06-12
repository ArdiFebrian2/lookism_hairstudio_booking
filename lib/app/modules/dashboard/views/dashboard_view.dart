import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Data statis untuk grafik
    final List<ChartData> chartData = [
      ChartData('Jan', 25),
      ChartData('Feb', 30),
      ChartData('Mar', 28),
      ChartData('Apr', 34),
      ChartData('Mei', 40),
      ChartData('Jun', 22),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Statistik Pemesanan Bulanan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Grafik batang
            SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: 'Pemesanan per Bulan'),
              tooltipBehavior: TooltipBehavior(enable: true),
              // series: <ChartSeries>[
              //   ColumnSeries<ChartData, String>(
              //     dataSource: chartData,
              //     xValueMapper: (ChartData data, _) => data.bulan,
              //     yValueMapper: (ChartData data, _) => data.jumlah,
              //     name: 'Pemesanan',
              //     color: Colors.deepPurple,
              //     dataLabelSettings: const DataLabelSettings(isVisible: true),
              //   )
              // ],
            ),

            const SizedBox(height: 32),

            // Contoh menu tambahan
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _dashboardCard(Icons.shopping_cart, 'Total Pesanan', '120'),
                _dashboardCard(Icons.people, 'Customer', '87'),
                _dashboardCard(Icons.store, 'UMKM Terdaftar', '45'),
                _dashboardCard(Icons.star, 'Rating Rata-rata', '4.5'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Card untuk menu cepat/statistik kecil
  Widget _dashboardCard(IconData icon, String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.deepPurple),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Data model untuk grafik
class ChartData {
  final String bulan;
  final double jumlah;

  ChartData(this.bulan, this.jumlah);
}
