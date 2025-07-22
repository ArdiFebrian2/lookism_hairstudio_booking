import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/booking_model.dart';

class RiwayatController extends GetxController {
  final isLoading = true.obs;
  final bookings = <BookingModel>[].obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  void fetchBookings() async {
    isLoading.value = true;
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        bookings.clear();
        return;
      }

      final snapshot =
          await _firestore
              .collection('bookings')
              .where('userId', isEqualTo: uid)
              .orderBy('datetime', descending: true)
              .get();

      final results = await Future.wait(
        snapshot.docs.map((doc) async {
          final data = doc.data();
          final barbermanId = data['barbermanId'];

          String barbermanName = '';

          if (barbermanId != null && barbermanId != '') {
            final barberDoc =
                await _firestore.collection('users').doc(barbermanId).get();

            if (barberDoc.exists && barberDoc.data()?['role'] == 'baberman') {
              barbermanName = barberDoc.data()?['nama'] ?? '';
            }
          }

          return BookingModel.fromMap(
            doc.id,
            data,
            barbermanName: barbermanName,
          );
        }).toList(),
      );

      bookings.assignAll(results);
    } catch (e) {
      print('Error fetching bookings: $e');
      bookings.clear();
    } finally {
      isLoading.value = false;
    }
  }

  String getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Menunggu';
      case 'accepted':
        return 'Diterima';
      case 'done':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return 'Tidak Diketahui';
    }
  }
}
