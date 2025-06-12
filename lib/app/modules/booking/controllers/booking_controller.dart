import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingController extends GetxController {
  final namaC = TextEditingController();
  final tanggalC = TextEditingController();
  final jamC = TextEditingController();
  var metodePembayaran = 'Tunai'.obs;

  void pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );

    if (picked != null) {
      tanggalC.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  void pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      jamC.text = picked.format(context);
    }
  }

  void konfirmasiBooking(Map<String, dynamic> layanan) {
    if (namaC.text.isEmpty || tanggalC.text.isEmpty || jamC.text.isEmpty) {
      Get.snackbar("Validasi", "Harap lengkapi semua data!");
      return;
    }

    Get.defaultDialog(
      title: "Booking Berhasil",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Layanan: ${layanan['nama']}"),
          Text("Tanggal: ${tanggalC.text}"),
          Text("Jam: ${jamC.text}"),
          Text("Pembayaran: ${metodePembayaran.value}"),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () => Get.offAllNamed('/navbar-customer'),
        child: const Text("Kembali ke Beranda"),
      ),
    );
  }
}
