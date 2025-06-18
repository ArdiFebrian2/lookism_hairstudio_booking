import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lookism_hairstudio_booking/app/data/models/service_model.dart';

class ServiceController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final RxList<ServiceModel> services = <ServiceModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices(); // Default untuk customer (hanya yang aktif)
  }

  /// Digunakan oleh customer dan admin untuk melihat layanan
  Future<void> fetchServices({bool showInactive = false}) async {
    try {
      isLoading.value = true;

      Query query = firestore.collection('services');
      if (!showInactive) {
        query = query.where('isActive', isEqualTo: true);
      }
      query = query.orderBy('name');

      final snapshot = await query.get();

      services.value =
          snapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>?;
                return ServiceModel.fromJson({
                  'id': doc.id,
                  ...?data, // null-aware spread untuk hindari error
                });
              })
              .whereType<ServiceModel>()
              .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load services: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Tambah layanan - hanya untuk admin
  Future<void> addService(ServiceModel service) async {
    try {
      await firestore.collection('services').add(service.toJson());
      Get.snackbar('Success', 'Layanan berhasil ditambahkan');
      fetchServices(showInactive: true); // Refresh untuk admin
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan layanan: $e');
    }
  }

  /// Update layanan - hanya untuk admin
  Future<void> updateService(ServiceModel service) async {
    if (service.id == null) {
      Get.snackbar('Error', 'ID layanan tidak ditemukan');
      return;
    }

    try {
      await firestore
          .collection('services')
          .doc(service.id)
          .update(service.toJson());
      Get.snackbar('Success', 'Layanan berhasil diperbarui');
      fetchServices(showInactive: true);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui layanan: $e');
    }
  }

  /// Hapus layanan - hanya untuk admin
  Future<void> deleteService(String serviceId) async {
    try {
      await firestore.collection('services').doc(serviceId).delete();
      Get.snackbar('Success', 'Layanan berhasil dihapus');
      fetchServices(showInactive: true);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus layanan: $e');
    }
  }
}
