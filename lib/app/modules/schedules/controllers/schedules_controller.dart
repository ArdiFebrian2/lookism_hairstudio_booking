import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/data/models/schedules_model.dart';

class SchedulesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxList<ScheduleModel> schedules = <ScheduleModel>[].obs;
  RxBool isLoading = false.obs;

  // 🟢 Cek dan tampilkan user login
  void logCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      print("👤 User login: ${user.uid}");
    } else {
      print("⚠️ Tidak ada user yang login.");
    }
  }

  // 🔄 Fetch semua jadwal untuk 1 barber
  Future<void> fetchSchedules(String barberId) async {
    isLoading.value = true;
    try {
      logCurrentUser(); // log saat fetch
      final snapshot =
          await _firestore
              .collection('schedules')
              .where('barberId', isEqualTo: barberId)
              .orderBy('date')
              .get();

      schedules.value =
          snapshot.docs
              .map((doc) => ScheduleModel.fromJson(doc.id, doc.data()))
              .toList();
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil jadwal: $e");
    }
    isLoading.value = false;
  }

  // ➕ Tambah jadwal baru
  Future<void> addSchedule(ScheduleModel schedule) async {
    try {
      print("📝 addSchedule() called: ${schedule.toJson()}");

      final user = _auth.currentUser;
      if (user == null) {
        Get.snackbar("Error", "User belum login");
        print("⛔ Gagal tambah jadwal: tidak ada user login");
        return;
      }

      final docRef = await _firestore
          .collection('schedules')
          .add(schedule.toJson());

      print("✅ Jadwal berhasil ditambahkan");
      print("📄 Dokumen ID: ${docRef.id}");
      print("📂 Path dokumen: ${docRef.path}");

      // Refresh daftar
      await fetchSchedules(schedule.barberId);
    } catch (e) {
      print("❌ Gagal menambahkan jadwal: $e");
      Get.snackbar("Error", "Gagal menambahkan jadwal: $e");
    }
  }

  // ❌ Hapus jadwal
  Future<void> deleteSchedule(String id) async {
    try {
      await _firestore.collection('schedules').doc(id).delete();
      schedules.removeWhere((schedule) => schedule.id == id);
      print("🗑️ Jadwal $id berhasil dihapus");
    } catch (e) {
      print("❌ Gagal hapus jadwal: $e");
      Get.snackbar("Error", "Gagal menghapus jadwal: $e");
    }
  }
}
