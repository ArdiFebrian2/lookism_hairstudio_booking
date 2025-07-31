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

  /// Ambil data layanan dari Firestore
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
            return ServiceModel.fromJson({'id': doc.id, ...?data});
          }).toList();
    } catch (e) {
      debugPrint("Fetch services error: $e");
      Get.snackbar('Error', 'Gagal memuat layanan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Tambah layanan baru
  Future<void> addService(ServiceModel service) async {
    try {
      await firestore.collection('services').add(service.toJson());
      Get.snackbar('Success', 'Layanan berhasil ditambahkan');
      await fetchServices(showInactive: true);
    } catch (e) {
      debugPrint("Add service error: $e");
      Get.snackbar('Error', 'Gagal menambahkan layanan: $e');
    }
  }

  /// Perbarui layanan
  /// Perbarui layanan berdasarkan nama
  Future<void> updateService(ServiceModel updatedService) async {
    try {
      if (updatedService.id == null) {
        Get.snackbar('Gagal', 'ID layanan tidak ditemukan');
        return;
      }

      final docRef = firestore.collection('services').doc(updatedService.id);

      final updateData = Map<String, dynamic>.from(updatedService.toJson());
      updateData.remove('id'); // ID tidak perlu diupdate di Firestore

      await docRef.update(updateData);
      Get.snackbar('Success', 'Layanan berhasil diperbarui');
      await fetchServices(showInactive: true);
    } catch (e) {
      debugPrint("Update service error: $e");
      Get.snackbar('Error', 'Gagal memperbarui layanan: $e');
    }
  }

  /// Hapus layanan berdasarkan ID
  Future<void> deleteService(
    String serviceId, {
    VoidCallback? onSuccess,
  }) async {
    try {
      await firestore.collection('services').doc(serviceId).delete();

      await fetchServices(showInactive: true);

      onSuccess?.call();
    } catch (e) {
      debugPrint("Delete service error: $e");
      Get.snackbar('Error', 'Gagal menghapus layanan: $e');
    }
  }

  /// Hapus layanan berdasarkan nama (fallback jika ID null)
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

      final batch = firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      await fetchServices(showInactive: true);

      onSuccess?.call();
    } catch (e) {
      debugPrint("Delete by name error: $e");
      Get.snackbar('Error', 'Gagal menghapus layanan: $e');
    }
  }

  /// Cari layanan berdasarkan ID
  ServiceModel? getServiceById(String id) {
    try {
      return services.firstWhere((service) => service.id == id);
    } catch (e) {
      debugPrint("Get by ID error: $e");
      return null;
    }
  }

  /// Cari layanan berdasarkan nama
  ServiceModel? getServiceByName(String name) {
    try {
      return services.firstWhere((service) => service.name == name);
    } catch (e) {
      debugPrint("Get by name error: $e");
      return null;
    }
  }
}
