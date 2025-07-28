import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../controllers/report_controller.dart';

class ReportView extends StatelessWidget {
  final controller = Get.put(ReportController());
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Laporan Penghasilan')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.exportToPDF,
        icon: Icon(Icons.picture_as_pdf),
        label: Text('Export PDF'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async => controller.fetchReportData(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildDateSelector('Dari', true)),
                    SizedBox(width: 8),
                    Expanded(child: _buildDateSelector('Sampai', false)),
                  ],
                ),
                SizedBox(height: 16),
                _buildIncomeCard('Hari Ini', controller.daily.value),
                _buildIncomeCard('Minggu Ini', controller.weekly.value),
                _buildIncomeCard('Bulan Ini', controller.monthly.value),
                SizedBox(height: 24),
                _buildChart(),
                SizedBox(height: 24),
                Text(
                  'Riwayat Transaksi:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...controller.reports.map(
                  (r) => ListTile(
                    title: Text('${r.serviceName} - ${r.barberName}'),
                    subtitle: Text(
                      DateFormat('dd MMM yyyy').format(r.createdAt),
                    ),
                    trailing: Text(currencyFormatter.format(r.amount)),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildIncomeCard(String title, double value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          currencyFormatter.format(value),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDateSelector(String label, bool isStart) {
    final selected =
        isStart
            ? controller.selectedStartDate.value
            : controller.selectedEndDate.value;

    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          if (isStart) {
            // Validasi: start tidak boleh melebihi end
            if (controller.selectedEndDate.value != null &&
                picked.isAfter(controller.selectedEndDate.value!)) {
              Get.snackbar(
                'Tanggal tidak valid',
                'Tanggal mulai tidak boleh setelah tanggal selesai.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
              );
              return;
            }
            controller.selectedStartDate.value = picked;
          } else {
            // Validasi: end tidak boleh sebelum start
            if (controller.selectedStartDate.value != null &&
                picked.isBefore(controller.selectedStartDate.value!)) {
              Get.snackbar(
                'Tanggal tidak valid',
                'Tanggal selesai tidak boleh sebelum tanggal mulai.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
              );
              return;
            }
            controller.selectedEndDate.value = picked;
          }
          controller.fetchReportData();
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          selected != null
              ? DateFormat('dd MMM yyyy').format(selected)
              : 'Pilih tanggal',
        ),
      ),
    );
  }

  Widget _buildChart() {
    final data =
        controller.reports
            .groupBy((r) => DateFormat('EEE').format(r.createdAt))
            .map(
              (day, entries) =>
                  MapEntry(day, entries.fold(0.0, (sum, r) => sum + r.amount)),
            )
            .entries
            .map((e) => _ChartData(e.key, e.value))
            .toList();

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <CartesianSeries<_ChartData, String>>[
        ColumnSeries<_ChartData, String>(
          dataSource: data,
          xValueMapper: (d, _) => d.day,
          yValueMapper: (d, _) => d.amount,
        ),
      ],
    );
  }
}

class _ChartData {
  final String day;
  final double amount;

  _ChartData(this.day, this.amount);
}

extension<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) {
    final map = <K, List<E>>{};
    for (var element in this) {
      final key = keyFunction(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }
}
