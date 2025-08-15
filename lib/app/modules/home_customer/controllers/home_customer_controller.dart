import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/data/models/service_model.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_customer/widgets/booking_buttom_sheet.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/controllers/service_controller.dart';

class HomeCustomerController extends GetxController {
  late final ServiceController serviceController;

  final selectedBarberman = Rxn<String>();
  final selectedDate = Rxn<DateTime>();
  final selectedTime = Rxn<TimeOfDay>();
  final isSubmitting = RxBool(false);

  late final String userId;

  /// ✅ Simpan jadwal tersedia
  final availableSchedules = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (Get.isRegistered<ServiceController>()) {
      serviceController = Get.find<ServiceController>();
    } else {
      serviceController = Get.put(ServiceController());
    }
    fetchServices();
  }

  void fetchServices() {
    serviceController.fetchServices(showInactive: false);
  }

  Future<List<QueryDocumentSnapshot>> getBarbers() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'baberman')
            .get();
    return snapshot.docs;
  }

  void resetBookingForm() {
    selectedBarberman.value = null;
    selectedDate.value = null;
    selectedTime.value = null;
    isSubmitting.value = false;
    availableSchedules.clear();
  }

  void showBookingDialog(BuildContext context, ServiceModel service) {
    Get.bottomSheet(
      BookingBottomSheet(service: service),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      selectedDate.value = picked;

      // Fetch jadwal setelah pilih tanggal
      if (selectedBarberman.value != null) {
        final formattedDate =
            "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        await fetchAvailableSchedules(selectedBarberman.value!, formattedDate);
      }
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final pickedMinutes = picked.hour * 60 + picked.minute;
      const minMinutes = 9 * 60; // 09:00
      const maxMinutes = 21 * 60; // 21:00

      if (pickedMinutes < minMinutes || pickedMinutes > maxMinutes) {
        Get.snackbar(
          'Waktu tidak valid',
          'Silakan pilih waktu antara jam 09:00 hingga 21:00',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      selectedTime.value = picked;
    }
  }

  bool validateBookingForm() {
    return selectedBarberman.value != null &&
        selectedDate.value != null &&
        selectedTime.value != null;
  }

  /// Ambil jadwal tersedia (belum dibooking)
  Future<void> fetchAvailableSchedules(String barbermanId, String date) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('schedules')
              .where('barberId', isEqualTo: barbermanId)
              .where('date', isEqualTo: date)
              .where('isBooked', isEqualTo: false)
              .get();

      availableSchedules.value =
          snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();

      // Debug
      print("📅 Jadwal tersedia: $availableSchedules");
    } catch (e) {
      Get.snackbar("Gagal", "Gagal memuat jadwal: $e");
    }
  }

  Future<bool> isScheduleAvailable(
    String barbermanId,
    DateTime bookingDateTime,
  ) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('bookings')
            .where('barbermanId', isEqualTo: barbermanId)
            .where('datetime', isEqualTo: bookingDateTime.toIso8601String())
            .get();

    return snapshot.docs.isEmpty;
  }

  /// Helper: normalisasi format waktu "09:00"
  String _normalizeTime(String time) {
    final parts = time.split(':');
    final hour = parts[0].padLeft(2, '0');
    final minute = parts[1].padLeft(2, '0');
    return "$hour:$minute";
  }

  /// Submit booking jika jadwal tersedia
  /// Submit booking jika jadwal tersedia
  Future<void> submitBooking(ServiceModel service) async {
    if (!validateBookingForm()) {
      Get.snackbar(
        'Oops!',
        'Mohon lengkapi semua data booking',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isSubmitting.value = true;

    try {
      final bookingDateTime = DateTime(
        selectedDate.value!.year,
        selectedDate.value!.month,
        selectedDate.value!.day,
        selectedTime.value!.hour,
        selectedTime.value!.minute,
      );

      final dateStr =
          "${selectedDate.value!.year.toString().padLeft(4, '0')}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}";

      final timeStr =
          "${selectedTime.value!.hour.toString().padLeft(2, '0')}:${selectedTime.value!.minute.toString().padLeft(2, '0')}";

      print("🔍 Mencari jadwal date=$dateStr, time=$timeStr");

      // ✅ 1. Cek apakah customer sudah booking hari itu
      final existingBooking =
          await FirebaseFirestore.instance
              .collection('bookings')
              .where('userId', isEqualTo: userId)
              .where('dateOnly', isEqualTo: dateStr)
              .get();

      if (existingBooking.docs.isNotEmpty) {
        Get.snackbar(
          'Booking Ditolak',
          'Kamu hanya bisa booking sekali dalam sehari',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      // ✅ 2. Cek bentrokan (overlap) slot waktu
      final startMinutes =
          selectedTime.value!.hour * 60 + selectedTime.value!.minute;
      final endMinutes =
          startMinutes +
          (service.durationMinutes ?? 30); // default 30 menit kalau null

      final barbermanBookings =
          await FirebaseFirestore.instance
              .collection('bookings')
              .where('barbermanId', isEqualTo: selectedBarberman.value)
              .where('dateOnly', isEqualTo: dateStr)
              .get();

      for (var doc in barbermanBookings.docs) {
        final data = doc.data();
        final bookedStart = data['startMinutes'] ?? 0;
        final bookedEnd = data['endMinutes'] ?? 0;

        final isOverlap = startMinutes < bookedEnd && endMinutes > bookedStart;
        if (isOverlap) {
          Get.snackbar(
            'Slot Bentrok',
            'Waktu yang kamu pilih berbenturan dengan booking lain',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
          return;
        }
      }

      // ✅ 3. Tambahkan booking baru
      await FirebaseFirestore.instance.collection('bookings').add({
        'userId': userId,
        'serviceName': service.name,
        'barbermanId': selectedBarberman.value,
        'datetime': bookingDateTime.toIso8601String(),
        'dateOnly': dateStr,
        'startMinutes': startMinutes,
        'endMinutes': endMinutes,
        'status': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
      });

      // ✅ 4. Tandai jadwal sebagai isBooked: true
      final selectedSchedule = availableSchedules.firstWhereOrNull((s) {
        return s['date'] == dateStr &&
            _normalizeTime(s['startTime']) == _normalizeTime(timeStr);
      });
      if (selectedSchedule != null) {
        await FirebaseFirestore.instance
            .collection('schedules')
            .doc(selectedSchedule['id'])
            .update({'isBooked': true});
      }

      Get.back(); // Close bottom sheet
      Get.snackbar(
        'Berhasil! 🎉',
        'Booking berhasil dibuat.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      resetBookingForm();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
