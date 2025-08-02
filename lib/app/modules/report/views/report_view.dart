import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/report_controller.dart';

class ReportView extends StatelessWidget {
  ReportView({super.key});
  final controller = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Pendapatan Umum'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => controller.generatePdf(),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: controller.selectedMonth,
                    decoration: const InputDecoration(labelText: 'Bulan'),
                    items: List.generate(12, (index) {
                      final month = (index + 1).toString().padLeft(2, '0');
                      return DropdownMenuItem(
                        value: '${DateTime.now().year}-$month',
                        child: Text(
                          DateFormat.MMMM(
                            'id_ID',
                          ).format(DateTime(0, index + 1)),
                        ),
                      );
                    }),
                    onChanged: (value) {
                      controller.selectedMonth = value;
                      controller.selectedDate = null;
                      controller.fetchReports(month: value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: controller.selectedYear,
                    decoration: const InputDecoration(labelText: 'Tahun'),
                    items: List.generate(5, (index) {
                      final year = DateTime.now().year - index;
                      return DropdownMenuItem(
                        value: year,
                        child: Text('$year'),
                      );
                    }),
                    onChanged: (value) {
                      controller.selectedYear = value;
                      controller.selectedDate = null;
                      controller.fetchReports(
                        month: controller.selectedMonth,
                        year: value,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(
                      controller.selectedDate != null
                          ? DateFormat(
                            'dd MMMM yyyy',
                          ).format(controller.selectedDate!)
                          : 'Pilih Tanggal',
                    ),
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        controller.selectedDate = pickedDate;
                        controller.selectedMonth = null;
                        controller.selectedYear = null;
                        controller.fetchReports(date: pickedDate);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.reports.isEmpty) {
                return const Center(child: Text('Belum ada data laporan'));
              }

              final totalRevenue = controller.reports.fold<int>(
                0,
                (sum, item) => sum + ((item['totalRevenue'] ?? 0) as int),
              );

              final totalBookings = controller.reports.fold<int>(
                0,
                (sum, item) => sum + ((item['totalBookings'] ?? 0) as int),
              );

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total Booking: $totalBookings',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Total Pendapatan: ${currency.format(totalRevenue)}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
