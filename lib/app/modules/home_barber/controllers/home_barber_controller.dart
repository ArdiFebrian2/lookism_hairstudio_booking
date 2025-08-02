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

        final status = data['status'];
        if (status == 'selesai' || status == 'rejected') continue;

        final String? userId = data['userId'];
        if (userId != null && userId.isNotEmpty) {
          try {
            final userDoc =
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get();

            final userData = userDoc.data();
            final bool isCustomer = userData?['role'] == 'customer';

            if (isCustomer) {
              data['customerName'] = userData?['name'] ?? 'Tidak diketahui';
              data['customerEmail'] = userData?['email'] ?? '-';
              data['customerPhone'] = userData?['phone'] ?? '-';

              // ✅ Ambil harga berdasarkan serviceName
              final String serviceName = data['serviceName'] ?? '';
              int price = 0;

              if (serviceName.isNotEmpty) {
                final serviceQuery =
                    await FirebaseFirestore.instance
                        .collection('services')
                        .where('name', isEqualTo: serviceName)
                        .limit(1)
                        .get();

                if (serviceQuery.docs.isNotEmpty) {
                  final serviceData = serviceQuery.docs.first.data();
                  final rawPrice = serviceData['price'];

                  if (rawPrice is int) {
                    price = rawPrice;
                  } else if (rawPrice is double) {
                    price = rawPrice.toInt();
                  }
                }
              }

              data['price'] = price;
              bookingList.add(data);
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

  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      final bookingRef = FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId);

      await bookingRef.update({'status': status});

      if (status == 'selesai') {
        final bookingDoc = await bookingRef.get();
        final data = bookingDoc.data();
        if (data == null) throw Exception('Data booking tidak ditemukan');

        final String serviceName = data['serviceName'] ?? '';
        final String barbermanId = data['barbermanId'] ?? '';
        final now = DateTime.now();
        final String month =
            '${now.year}-${now.month.toString().padLeft(2, '0')}';

        int price = 0;

        // ✅ Ambil harga dari koleksi `services` berdasarkan serviceName
        if (serviceName.isNotEmpty) {
          final serviceQuery =
              await FirebaseFirestore.instance
                  .collection('services')
                  .where('name', isEqualTo: serviceName)
                  .limit(1)
                  .get();

          if (serviceQuery.docs.isNotEmpty) {
            final serviceData = serviceQuery.docs.first.data();
            final rawPrice = serviceData['price'];

            if (rawPrice is int) {
              price = rawPrice;
            } else if (rawPrice is double) {
              price = rawPrice.toInt();
            }
          }
        }

        // ✅ Ambil nama barberman dari koleksi users
        String barbermanName = 'Barber';
        if (barbermanId.isNotEmpty) {
          final userDoc =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(barbermanId)
                  .get();

          final userData = userDoc.data();
          if (userDoc.exists && userData?['role'] == 'baberman') {
            barbermanName = userData?['name'] ?? 'Barber';
          }
        }

        // ✅ Simpan atau update laporan di koleksi `reports`
        final reportRef = FirebaseFirestore.instance
            .collection('reports')
            .doc('$barbermanId-$month');

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final snapshot = await transaction.get(reportRef);

          if (snapshot.exists) {
            final currentData = snapshot.data()!;
            transaction.update(reportRef, {
              'totalRevenue': (currentData['totalRevenue'] ?? 0) + price,
              'totalBookings': (currentData['totalBookings'] ?? 0) + 1,
            });
          } else {
            transaction.set(reportRef, {
              'barbermanId': barbermanId,
              'barbermanName': barbermanName,
              'month': month,
              'totalRevenue': price,
              'totalBookings': 1,
              'createdAt': now,
            });
          }
        });
      }

      Get.snackbar(
        'Berhasil',
        status == 'accepted'
            ? 'Booking diterima'
            : status == 'selesai'
            ? 'Booking selesai dan dicatat ke laporan'
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

      fetchBookings();
    } catch (e) {
      debugPrint('❌ Gagal update status booking: $e');
      Get.snackbar('Error', 'Gagal memperbarui status booking');
    }
  }
}
