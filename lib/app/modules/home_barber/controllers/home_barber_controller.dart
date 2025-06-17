import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/data/models/booking_model.dart';

class HomeBarberController extends GetxController {
  final bookings = <BookingModel>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentBarbermanId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void onInit() {
    super.onInit();
    listenToBookings();
  }

  void listenToBookings() {
    try {
      _firestore
          .collection('bookings')
          .where('barberman_id', isEqualTo: currentBarbermanId)
          .orderBy('booking_date')
          .snapshots()
          .listen((snapshot) {
            bookings.value =
                snapshot.docs
                    .map((doc) => BookingModel.fromMap(doc.id, doc.data()))
                    .toList();
          });
    } on FirebaseException catch (e) {
      if (e.code == 'failed-precondition') {
        Get.snackbar(
          'Index Belum Siap',
          'Firestore index sedang dibangun. Tunggu beberapa menit lalu coba lagi.',
        );
      } else {
        Get.snackbar('Error', 'Gagal memuat jadwal: ${e.message}');
      }
    }
  }

  Future<void> markAsServed(BookingModel booking) async {
    try {
      await _firestore.collection('bookings').doc(booking.id).update({
        'status': 'selesai',
      });

      Get.snackbar('Sukses', 'Jadwal ditandai sebagai selesai');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui status: $e');
    }
  }
}
