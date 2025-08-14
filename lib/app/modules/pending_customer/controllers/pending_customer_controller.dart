import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PendingCustomerController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var pendingCustomers = <QueryDocumentSnapshot>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingCustomers();
  }

  /// Ambil daftar customer pending secara realtime
  void fetchPendingCustomers() {
    isLoading.value = true;
    _firestore
        .collection('users')
        .where('role', isEqualTo: 'customer')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
          pendingCustomers.value = snapshot.docs;
          isLoading.value = false;
        });
  }

  /// Approve customer
  Future<void> approveCustomer(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'status': 'approved',
      });
      Get.snackbar('Berhasil', 'Customer berhasil disetujui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyetujui: $e');
    }
  }

  /// Tolak customer
  Future<void> rejectCustomer(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      Get.snackbar('Berhasil', 'Customer berhasil ditolak');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menolak: $e');
    }
  }
}
