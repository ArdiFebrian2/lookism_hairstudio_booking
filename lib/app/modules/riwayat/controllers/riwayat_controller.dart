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
    try {
      isLoading.value = true;
      final uid = _auth.currentUser?.uid;

      if (uid == null) {
        bookings.clear();
        return;
      }

      final query =
          await _firestore
              .collection('bookings')
              .where('userId', isEqualTo: uid)
              .orderBy('datetime', descending: true)
              .get();

      final data =
          query.docs
              .map((doc) => BookingModel.fromMap(doc.id, doc.data()))
              .toList();

      bookings.assignAll(data);
    } catch (e) {
      print('Error fetching bookings: $e');
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
