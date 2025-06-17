import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class JadwalBabermanController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var barbermen = <Map<String, dynamic>>[].obs;
  var services = <Map<String, String>>[].obs;

  var selectedBarbermanId = ''.obs;
  var selectedService = ''.obs;

  final dateC = TextEditingController();
  final timeC = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBarbermen();
    fetchServices();
  }

  // Ambil data barberman
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
            return {
              'id': doc.id,
              'name': data['nama']?.toString() ?? 'Tanpa Nama',
            };
          }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat barberman: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Ambil data layanan dari koleksi 'services'
  void fetchServices() async {
    try {
      final snapshot = await _firestore.collection('services').get();
      services.value =
          snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'name': data['name']?.toString() ?? 'Layanan Tanpa Nama',
            };
          }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat layanan: $e');
    }
  }

  void pickDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      selectedDate = picked;
      dateC.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

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

  String getDayName(DateTime date) {
    return DateFormat('EEEE', 'id_ID').format(date); // contoh: Senin
  }

  void saveJadwal() async {
    if (selectedBarbermanId.value.isEmpty ||
        selectedDate == null ||
        selectedTime == null ||
        selectedService.value.isEmpty) {
      Get.snackbar('Validasi', 'Semua field harus diisi');
      return;
    }

    try {
      isLoading.value = true;

      final bookingDate = dateC.text.trim();
      final bookingTime =
          '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';
      final day = getDayName(selectedDate!);

      print("📌 Proses simpan booking:");
      print("Barberman ID: ${selectedBarbermanId.value}");
      print("Tanggal: $bookingDate");
      print("Jam: $bookingTime");
      print("Layanan: ${selectedService.value}");

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
        'user_id': FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
        'barberman_id': selectedBarbermanId.value,
        'booking_date': bookingDate,
        'booking_time': bookingTime,
        'service_name': selectedService.value,
        'day': day,
        'status': 'menunggu',
        'created_at': FieldValue.serverTimestamp(),
      });

      Get.snackbar('Sukses', 'Jadwal berhasil ditambahkan');

      // Reset input
      selectedBarbermanId.value = '';
      selectedService.value = '';
      dateC.clear();
      timeC.clear();
      selectedDate = null;
      selectedTime = null;
    } catch (e) {
      print("❌ Error saat menyimpan jadwal: $e");
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
