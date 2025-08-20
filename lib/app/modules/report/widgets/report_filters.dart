import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lookism_hairstudio_booking/app/modules/report/controllers/report_controller.dart';

class ReportFilters extends StatelessWidget {
  final ReportController controller;

  const ReportFilters({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fieldWidth = (screenWidth - 16 * 2 - 12) / 2;

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Laporan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // ✅ Dropdown Bulan & Tahun
            Row(
              children: [
                Expanded(child: _buildMonthDropdown()),
                const SizedBox(width: 12),
                Expanded(child: _buildYearDropdown()),
              ],
            ),

            const SizedBox(height: 16),
            // ✅ Date Picker
            _buildDatePicker(context),

            const SizedBox(height: 20),

            // ✅ Tombol Cetak
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.print, size: 20),
                label: const Text(
                  "Cetak Laporan",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => controller.generatePdf(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthDropdown() {
    return SizedBox(
      width: double.infinity, // Biar dropdown ikut penuh tapi tetap aman
      child: DropdownButtonFormField<String>(
        value: controller.selectedMonth,
        decoration: _inputDecoration(
          label: 'Bulan',
          icon: Icons.calendar_month,
        ),
        isExpanded: true, // Supaya teks tidak terpotong
        items: List.generate(12, (index) {
          final month = (index + 1).toString().padLeft(2, '0');
          return DropdownMenuItem(
            value: month,
            child: Text(
              DateFormat.MMMM('id_ID').format(DateTime(0, index + 1)),
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis, // kalau teks kepanjangan
            ),
          );
        }),
        onChanged: (value) {
          controller.selectedMonth = value;
          controller.selectedDate = null;
          controller.fetchReports(month: value, year: controller.selectedYear);
        },
      ),
    );
  }

  Widget _buildYearDropdown() {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField<int>(
        value: controller.selectedYear,
        decoration: _inputDecoration(label: 'Tahun', icon: Icons.date_range),
        isExpanded: true,
        items: List.generate(5, (index) {
          final year = DateTime.now().year - index;
          return DropdownMenuItem(
            value: year,
            child: Text('$year', style: const TextStyle(fontSize: 14)),
          );
        }),
        onChanged: (value) {
          controller.selectedYear = value;
          controller.selectedDate = null;
          controller.fetchReports(month: controller.selectedMonth, year: value);
        },
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.calendar_today, size: 18),
        label: Text(
          controller.selectedDate != null
              ? DateFormat(
                'dd MMMM yyyy',
                'id_ID',
              ).format(controller.selectedDate!)
              : 'Pilih Tanggal',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal.shade50,
          foregroundColor: Colors.deepPurpleAccent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.deepPurple),
          ),
        ),
        onPressed: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Colors.deepPurpleAccent,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black87,
                  ),
                ),
                child: child!,
              );
            },
          );

          if (pickedDate != null) {
            controller.selectedDate = pickedDate;
            controller.selectedMonth = null;
            controller.selectedYear = null;
            controller.fetchReports(date: pickedDate);
          }
        },
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
