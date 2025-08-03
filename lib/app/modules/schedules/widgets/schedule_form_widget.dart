// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/data/models/schedules_model.dart';
import '../controllers/schedules_controller.dart';
import '../utils/time_utils.dart';

class ScheduleFormWidget extends StatelessWidget {
  final String barberId;
  final SchedulesController controller;

  final TextEditingController dateC = TextEditingController();
  final TextEditingController startC = TextEditingController();
  final TextEditingController endC = TextEditingController();

  ScheduleFormWidget({
    super.key,
    required this.barberId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormHeader(),
          const SizedBox(height: 20),
          _buildDateField(context),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStartTimeField(context)),
              const SizedBox(width: 16),
              Expanded(child: _buildEndTimeField(context)),
            ],
          ),
          const SizedBox(height: 24),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildFormHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.add_circle_outline,
            color: Colors.green.shade600,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          "Tambah Jadwal Baru",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tanggal",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: dateC,
          readOnly: true,
          onTap: () => _selectDate(context),
          decoration: InputDecoration(
            hintText: "Pilih tanggal",
            prefixIcon: Icon(Icons.calendar_today, color: Colors.blue.shade600),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }

  Widget _buildStartTimeField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Jam Mulai",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: startC,
          readOnly: true,
          onTap: () => _selectStartTime(context),
          decoration: InputDecoration(
            hintText: "09:00",
            prefixIcon: Icon(Icons.access_time, color: Colors.green.shade600),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green.shade600, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }

  Widget _buildEndTimeField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Jam Selesai",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: endC,
          readOnly: true,
          onTap: () => _selectEndTime(context),
          decoration: InputDecoration(
            hintText: "22:00",
            prefixIcon: Icon(
              Icons.access_time_filled,
              color: Colors.red.shade600,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade600, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _submitSchedule,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 20),
            const SizedBox(width: 8),
            const Text(
              "Tambah Jadwal",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Colors.blue.shade600),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dateC.text = picked.toIso8601String().split('T').first;
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Colors.green.shade600),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (!TimeUtils.isTimeInRange(picked)) {
        Get.snackbar(
          "Jam Tidak Valid",
          "Jam mulai harus antara 09:00 - 22:00",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          icon: Icon(Icons.error_outline, color: Colors.red.shade600),
        );
        return;
      }
      startC.text = TimeUtils.formatTimeOfDay24(picked);
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 17, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Colors.red.shade600),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (!TimeUtils.isTimeInRange(picked)) {
        Get.snackbar(
          "Jam Tidak Valid",
          "Jam selesai harus antara 09:00 - 22:00",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          icon: Icon(Icons.error_outline, color: Colors.red.shade600),
        );
        return;
      }
      endC.text = TimeUtils.formatTimeOfDay24(picked);
    }
  }

  void _submitSchedule() {
    if (dateC.text.isEmpty || startC.text.isEmpty || endC.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Semua field wajib diisi!",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        icon: Icon(Icons.error_outline, color: Colors.red.shade600),
      );
      return;
    }

    try {
      final startParts = startC.text.split(":");
      final endParts = endC.text.split(":");

      final start = TimeOfDay(
        hour: int.parse(startParts[0]),
        minute: int.parse(startParts[1]),
      );
      final end = TimeOfDay(
        hour: int.parse(endParts[0]),
        minute: int.parse(endParts[1]),
      );

      final startMinutes = start.hour * 60 + start.minute;
      final endMinutes = end.hour * 60 + end.minute;

      if (endMinutes <= startMinutes) {
        Get.snackbar(
          "Error",
          "Jam selesai harus lebih dari jam mulai",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          icon: Icon(Icons.error_outline, color: Colors.red.shade600),
        );
        return;
      }

      final schedule = ScheduleModel(
        id: '',
        barberId: barberId,
        date: dateC.text,
        startTime: startC.text,
        endTime: endC.text,
        isBooked: false,
      );

      controller.addSchedule(schedule);

      // Clear form
      dateC.clear();
      startC.clear();
      endC.clear();

      Get.snackbar(
        "Berhasil",
        "Jadwal berhasil ditambahkan!",
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        icon: Icon(Icons.check_circle_outline, color: Colors.green.shade600),
      );

      print("Menambahkan jadwal: ${schedule.toJson()}");
    } catch (e) {
      Get.snackbar(
        "Error",
        "Format jam tidak valid.",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        icon: Icon(Icons.error_outline, color: Colors.red.shade600),
      );
    }
  }
}
