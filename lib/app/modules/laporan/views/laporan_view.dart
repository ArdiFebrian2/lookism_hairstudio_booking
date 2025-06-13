import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/laporan_controller.dart';

class LaporanView extends GetView<LaporanController> {
  const LaporanView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LaporanController());
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Pemesanan'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown Periode
            Row(
              children: [
                const Text("Periode: "),
                const SizedBox(width: 10),
                Expanded(
                  child: Obx(
                    () => DropdownButton<String>(
                      value: controller.selectedPeriode.value,
                      isExpanded: true,
                      items:
                          controller.periodeList.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (newValue) {
                        controller.selectedPeriode.value = newValue!;
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Dropdown Status
            Row(
              children: [
                const Text("Status: "),
                const SizedBox(width: 10),
                Expanded(
                  child: Obx(
                    () => DropdownButton<String>(
                      value: controller.selectedStatus.value,
                      isExpanded: true,
                      items:
                          controller.statusList.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (newValue) {
                        controller.selectedStatus.value = newValue!;
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Dropdown Metode
            Row(
              children: [
                const Text("Metode: "),
                const SizedBox(width: 10),
                Expanded(
                  child: Obx(
                    () => DropdownButton<String>(
                      value: controller.selectedMetode.value,
                      isExpanded: true,
                      items:
                          controller.metodeList.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (newValue) {
                        controller.selectedMetode.value = newValue!;
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Total Penghasilan
            Obx(
              () => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepPurple.shade100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Penghasilan ${controller.selectedPeriode.value}:',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Rp ${controller.totalPenghasilan}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Generate PDF
            ElevatedButton.icon(
              onPressed: controller.generateLaporanPDF,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Generate Laporan (PDF)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
