import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBarberController extends GetxController {
  final bookings = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  late final String barberId;

  @override
  void onInit() {
    super.onInit();
    barberId = FirebaseAuth.instance.currentUser?.uid ?? '';
    fetchBookings();
  }

  /// Mengambil semua data booking berdasarkan barbermanId dan hanya jika user adalah customer
  void fetchBookings() async {
    isLoading.value = true;

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('bookings')
              .where('barbermanId', isEqualTo: barberId)
              .orderBy('datetime')
              .get();

      debugPrint('📦 Total Bookings: ${snapshot.docs.length}');
      final List<Map<String, dynamic>> bookingList = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;

        final String? userId = data['userId'];

        if (userId != null && userId.isNotEmpty) {
          try {
            final userDoc =
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get();

            if (userDoc.exists) {
              final userData = userDoc.data();
              final bool isCustomer = (userData?['role'] == 'customer');

              if (isCustomer) {
                data['customerName'] = userData?['name'] ?? 'Tidak diketahui';
                data['customerEmail'] = userData?['email'] ?? '-';
                data['customerPhone'] = userData?['phone'] ?? '-';
                bookingList.add(data);
              }
            }
          } catch (e) {
            debugPrint('❌ Gagal ambil data user ($userId): $e');
          }
        }
      }

      bookings.value = bookingList;
    } catch (e) {
      debugPrint('❌ Error saat fetchBookings: $e');
      Get.snackbar('Error', 'Gagal mengambil data booking');
    } finally {
      isLoading.value = false;
    }
  }

  /// Update status booking (accepted / rejected / selesai)
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'status': status});

      Get.snackbar(
        'Berhasil',
        status == 'accepted'
            ? 'Booking diterima'
            : status == 'selesai'
            ? 'Booking selesai'
            : 'Status booking diperbarui',
        snackPosition: SnackPosition.TOP,
        backgroundColor:
            status == 'accepted'
                ? Get.theme.primaryColor
                : status == 'selesai'
                ? Colors.green
                : Get.theme.colorScheme.error,
        colorText: Colors.white,
      );

      fetchBookings(); // Refresh data
    } catch (e) {
      debugPrint('❌ Gagal update status booking: $e');
      Get.snackbar('Error', 'Gagal memperbarui status booking');
    }
  }
}
