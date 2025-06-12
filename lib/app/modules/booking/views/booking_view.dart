import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/booking_controller.dart';

class BookingView extends GetView<BookingController> {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => BookingController());
    final layanan = Get.arguments?['layanan'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking Layanan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            layanan != null
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      layanan['nama'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      layanan['deskripsi'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                )
                : const Text(
                  "Layanan tidak tersedia",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
            const SizedBox(height: 24),
            _buildLabel("Nama Pelanggan"),
            TextField(
              controller: controller.namaC,
              decoration: _inputDecoration(
                "Masukkan nama lengkap",
                Icons.person,
              ),
            ),
            const SizedBox(height: 16),
            _buildLabel("Tanggal Booking"),
            TextField(
              controller: controller.tanggalC,
              readOnly: true,
              onTap: () => controller.pickDate(context),
              decoration: _inputDecoration(
                "Pilih tanggal",
                Icons.calendar_today,
              ),
            ),
            const SizedBox(height: 16),
            _buildLabel("Jam Booking"),
            TextField(
              controller: controller.jamC,
              readOnly: true,
              onTap: () => controller.pickTime(context),
              decoration: _inputDecoration("Pilih jam", Icons.access_time),
            ),
            const SizedBox(height: 16),
            _buildLabel("Metode Pembayaran"),
            DropdownButtonFormField<String>(
              value: controller.metodePembayaran.value,
              decoration: _inputDecoration("Pilih metode", Icons.payment),
              items:
                  ['Tunai', 'QRIS', 'Transfer Bank']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (value) => controller.metodePembayaran.value = value!,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => controller.konfirmasiBooking(layanan),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text(
                  "Konfirmasi Booking",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: Colors.black87,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
