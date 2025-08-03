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

  /// ✅ NEW: simpan jadwal tersedia
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

      // ✅ Fetch jadwal setelah pilih tanggal
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

  /// ✅ Ambil jadwal tersedia (belum dibooking)
  Future<void> fetchAvailableSchedules(String barbermanId, String date) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('schedules')
              .where('barberId', isEqualTo: barbermanId)
              .where('date', isEqualTo: date)
              .where('isBooked', isEqualTo: false)
              .orderBy('startTime')
              .get();

      availableSchedules.value =
          snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();
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

  /// ✅ Submit booking jika jadwal tersedia & belum dibooking
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

      // ✅ Cek apakah waktu dipilih ada di availableSchedules
      final selectedSchedule = availableSchedules.firstWhereOrNull(
        (s) => s['date'] == dateStr && s['startTime'] == timeStr,
      );

      if (selectedSchedule == null) {
        Get.snackbar(
          'Jadwal Baberman tidak tersedia',
          'Pilih Baberman lain dan waktu yang tersedia',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      // ✅ Cek ulang apakah belum dibooking (ganda)
      final isAvailable = await isScheduleAvailable(
        selectedBarberman.value!,
        bookingDateTime,
      );

      if (!isAvailable) {
        Get.snackbar(
          'Jadwal sudah dibooking',
          'Waktu ini telah diambil. Pilih jadwal lain.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      // ✅ Tambahkan ke bookings
      await FirebaseFirestore.instance.collection('bookings').add({
        'userId': userId,
        'serviceName': service.name,
        'barbermanId': selectedBarberman.value,
        'datetime': bookingDateTime.toIso8601String(),
        'status': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
      });

      // ✅ Tandai jadwal sebagai isBooked: true
      await FirebaseFirestore.instance
          .collection('schedules')
          .doc(selectedSchedule['id'])
          .update({'isBooked': true});

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
