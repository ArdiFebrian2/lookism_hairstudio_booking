import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JadwalBabermanController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var barbermen = <Map<String, String>>[].obs;
  var selectedBarbermanId = ''.obs;

  final dateC = TextEditingController();
  final timeC = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBarbermen();
  }

  /// Ambil daftar barberman dari Firestore
  void fetchBarbermen() async {
    try {
      isLoading.value = true;
      final snapshot =
          await _firestore
              .collection('users')
              .where('role', isEqualTo: 'baberman')
              .get();

      barbermen.value =
          snapshot.docs.map((doc) {
            final data = doc.data();
            final nama = data['nama'];
            return {
              'id': doc.id,
              'name':
                  (nama is String && nama.trim().isNotEmpty)
                      ? nama
                      : 'Tanpa Nama',
            };
          }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data barberman: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Pilih tanggal dari date picker
  void pickDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      selectedDate = picked;
      dateC.text = picked.toIso8601String().split('T').first;
    }
  }

  /// Pilih jam dari time picker
  void pickTime() async {
    final picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      selectedTime = picked;
      timeC.text = picked.format(Get.context!);
    }
  }

  /// Simpan jadwal baru ke Firestore
  void saveJadwal() async {
    if (selectedBarbermanId.value.isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      Get.snackbar('Validasi', 'Semua field harus diisi');
      return;
    }

    try {
      isLoading.value = true;

      final bookingDate = dateC.text.trim();
      final bookingTime =
          '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';

      final snapshot =
          await _firestore
              .collection('bookings')
              .where('barberman_id', isEqualTo: selectedBarbermanId.value)
              .where('booking_date', isEqualTo: bookingDate)
              .where('booking_time', isEqualTo: bookingTime)
              .get();

      if (snapshot.docs.isNotEmpty) {
        Get.snackbar(
          'Jadwal Bentrok',
          'Barberman sudah memiliki jadwal di $bookingTime pada $bookingDate',
        );
        return;
      }

      await _firestore.collection('bookings').add({
        'user_id': '', // Admin membuat
        'barberman_id': selectedBarbermanId.value,
        'booking_date': bookingDate,
        'booking_time': bookingTime,
        'service_id': '', // Optional
        'status': 'menunggu',
        'created_at': FieldValue.serverTimestamp(),
      });

      Get.snackbar('Sukses', 'Jadwal berhasil ditambahkan');

      // Reset field
      selectedBarbermanId.value = '';
      dateC.clear();
      timeC.clear();
      selectedDate = null;
      selectedTime = null;
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan jadwal: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    dateC.dispose();
    timeC.dispose();
    super.onClose();
  }
}
