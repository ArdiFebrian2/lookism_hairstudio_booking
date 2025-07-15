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

  void fetchBookings() async {
    isLoading.value = true;

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('bookings')
              .where('barbermanId', isEqualTo: barberId)
              .orderBy('datetime')
              .get();

      final List<Map<String, dynamic>> bookingList = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;

        // Ambil nama customer jika userId ada
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
              if (userData != null && userData['role'] == 'customer') {
                data['customerName'] = userData['name'] ?? 'Tidak diketahui';
              } else {
                data['customerName'] = 'Bukan customer';
              }
            } else {
              data['customerName'] = 'User tidak ditemukan';
            }
          } catch (e) {
            debugPrint('Gagal ambil user $userId: $e');
            data['customerName'] = 'Error ambil nama';
          }
        } else {
          data['customerName'] = 'Tidak diketahui';
        }

        bookingList.add(data);
      }

      bookings.value = bookingList;
    } catch (e) {
      debugPrint('Error saat fetchBookings: $e');
      Get.snackbar('Error', 'Gagal mengambil data booking');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'status': status});

      Get.snackbar(
        'Berhasil',
        status == 'accepted' ? 'Booking diterima' : 'Booking ditolak',
        snackPosition: SnackPosition.TOP,
        backgroundColor:
            status == 'accepted'
                ? Get.theme.primaryColor
                : Get.theme.colorScheme.error,
        colorText: Colors.white,
      );

      fetchBookings(); // Refresh setelah update
    } catch (e) {
      debugPrint('Error saat updateBookingStatus: $e');
      Get.snackbar('Error', 'Gagal memperbarui status booking');
    }
  }
}
