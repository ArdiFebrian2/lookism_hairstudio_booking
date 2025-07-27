import 'package:flutter/material.dart';
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
    fetchServices();
  }

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
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>?;
            // Pastikan ID document disimpan dalam model
            return ServiceModel.fromJson({'id': doc.id, ...?data});
          }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load services: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addService(ServiceModel service) async {
    try {
      await firestore.collection('services').add(service.toJson());
      Get.snackbar('Success', 'Layanan berhasil ditambahkan');
      fetchServices(showInactive: true);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan layanan: $e');
    }
  }

  Future<void> updateService(ServiceModel service) async {
    if (service.id == null || service.id!.isEmpty) {
      Get.snackbar('Error', 'ID layanan tidak ditemukan');
      return;
    }

    try {
      // Buat copy data tanpa field 'id' untuk update
      final updateData = Map<String, dynamic>.from(service.toJson());
      updateData.remove('id'); // Hapus field id dari data yang akan diupdate

      await firestore.collection('services').doc(service.id).update(updateData);

      Get.snackbar('Success', 'Layanan berhasil diperbarui');
      fetchServices(showInactive: true);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui layanan: $e');
    }
  }

  // Method delete berdasarkan ID (lebih efisien dan aman)
  Future<void> deleteService(
    String serviceId, {
    VoidCallback? onSuccess,
  }) async {
    try {
      await firestore.collection('services').doc(serviceId).delete();

      // Refresh data setelah delete
      await fetchServices(showInactive: true);

      // Panggil callback jika disediakan
      onSuccess?.call();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus layanan: $e');
    }
  }

  // Method delete berdasarkan nama (jika masih diperlukan)
  Future<void> deleteServiceByName(
    String name, {
    VoidCallback? onSuccess,
  }) async {
    try {
      final querySnapshot =
          await firestore
              .collection('services')
              .where('name', isEqualTo: name)
              .get();

      if (querySnapshot.docs.isEmpty) {
        Get.snackbar('Gagal', 'Layanan "$name" tidak ditemukan');
        return;
      }

      // Delete semua dokumen yang ditemukan
      final batch = firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Refresh data setelah delete
      await fetchServices(showInactive: true);

      // Panggil callback jika disediakan
      onSuccess?.call();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus layanan: $e');
    }
  }

  // Method untuk mencari service berdasarkan ID
  ServiceModel? getServiceById(String id) {
    try {
      return services.firstWhere((service) => service.id == id);
    } catch (e) {
      return null;
    }
  }

  // Method untuk mencari service berdasarkan nama
  ServiceModel? getServiceByName(String name) {
    try {
      return services.firstWhere((service) => service.name == name);
    } catch (e) {
      return null;
    }
  }
}
