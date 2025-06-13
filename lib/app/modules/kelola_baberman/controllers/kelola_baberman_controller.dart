import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class KelolaBabermanController extends GetxController {
  final users = <Map<String, dynamic>>[].obs;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchBabermans();
  }

  /// Ambil semua data dengan role 'baberman'
  void fetchBabermans() {
    _firestore
        .collection('users')
        .where('role', isEqualTo: 'baberman')
        .snapshots()
        .listen((snapshot) {
          users.value =
              snapshot.docs.map((doc) {
                final data = doc.data();
                data['uid'] = doc.id;
                return data;
              }).toList();
        });
  }

  /// Tambah akun baberman (auth + firestore)
  Future<void> addBaberman({
    required String nama,
    required String email,
    required String password,
    required String alamat,
    required String telepon,
  }) async {
    try {
      // 1. Buat akun di Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      // 2. Simpan ke Firestore
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'nama': nama,
        'email': email,
        'alamat': alamat,
        'telepon': telepon,
        'role': 'baberman',
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar('Sukses', 'Akun Baberman berhasil dibuat');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Gagal membuat akun');
    }
  }

  /// Update data baberman di Firestore
  Future<void> updateBaberman(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
      Get.snackbar('Sukses', 'Data Baberman diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui data');
    }
  }

  /// Hapus data baberman dari Firestore
  Future<void> deleteBaberman(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      Get.snackbar('Dihapus', 'Data Baberman berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus data');
    }
  }
}
