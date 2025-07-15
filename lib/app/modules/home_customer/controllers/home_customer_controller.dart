import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/data/models/service_model.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_customer/widgets/booking_buttom_sheet.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/controllers/service_controller.dart';

class HomeCustomerController extends GetxController {
  late final ServiceController serviceController;

  // Booking form variables
  final selectedBarberman = Rxn<String>();
  final selectedDate = Rxn<DateTime>();
  final selectedTime = Rxn<TimeOfDay>();
  final isSubmitting = RxBool(false);

  @override
  void onInit() {
    super.onInit();
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.deepPurple),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) selectedDate.value = picked;
  }

  Future<void> selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.deepPurple),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Validasi waktu booking hanya antara 09:00 - 21:00
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

      await FirebaseFirestore.instance.collection('bookings').add({
        'serviceId': service.id,
        'serviceName': service.name,
        'barbermanId': selectedBarberman.value,
        'datetime': bookingDateTime.toIso8601String(),
        'status': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
      });

      Get.back(); // Close the bottom sheet
      Get.snackbar(
        'Berhasil! 🎉',
        'Booking berhasil dibuat. Menunggu konfirmasi.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      resetBookingForm();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan. Silakan coba lagi.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
