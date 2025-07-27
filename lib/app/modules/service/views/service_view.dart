import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/data/models/service_model.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/controllers/service_controller.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/widgets/service_form_widget.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/widgets/service_card_widget.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/widgets/empty_state_widget.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/widgets/service_edit_form_widget.dart';

class ServiceView extends StatelessWidget {
  final ServiceController controller = Get.put(ServiceController());
  final RxBool showForm = false.obs;

  ServiceView({super.key});

  void confirmDelete(ServiceModel service) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus layanan "${service.name}"?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              // Tutup dialog terlebih dahulu
              Get.back();

              // Gunakan ID untuk delete (lebih aman dan efisien)
              if (service.id != null && service.id!.isNotEmpty) {
                await controller.deleteService(
                  service.id!,
                  onSuccess: () {
                    Get.snackbar(
                      'Berhasil',
                      'Layanan "${service.name}" berhasil dihapus.',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  },
                );
              } else {
                // Fallback ke delete by name jika ID tidak tersedia
                await controller.deleteServiceByName(
                  service.name,
                  onSuccess: () {
                    Get.snackbar(
                      'Berhasil',
                      'Layanan "${service.name}" berhasil dihapus.',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  },
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void showEditForm(ServiceModel service) {
    // Pastikan service memiliki ID sebelum edit
    if (service.id == null || service.id!.isEmpty) {
      Get.snackbar(
        'Error',
        'ID layanan tidak ditemukan. Tidak dapat mengedit.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: ServiceEditFormWidget(
          service: service,
          onFormSubmitted: () {
            Get.back(); // Tutup dialog
            controller.fetchServices(showInactive: true); // Refresh data
          },
          onFormCancelled: () => Get.back(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch data saat build pertama kali
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchServices(showInactive: true);
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Kelola Layanan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade200),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchServices(showInactive: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header + tombol tambah
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar Layanan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Obx(
                    () => ElevatedButton.icon(
                      onPressed: () => showForm.value = !showForm.value,
                      icon: Icon(showForm.value ? Icons.close : Icons.add),
                      label: Text(showForm.value ? 'Tutup' : 'Tambah Layanan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            showForm.value ? Colors.grey : Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Form Tambah Layanan
              Obx(
                () => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child:
                      showForm.value
                          ? Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: ServiceFormWidget(
                                onFormSubmitted: () {
                                  showForm.value = false;
                                  controller.fetchServices(showInactive: true);
                                },
                                onFormCancelled: () => showForm.value = false,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
              ),

              // Spacing jika form ditampilkan
              Obx(
                () =>
                    showForm.value
                        ? const SizedBox(height: 16)
                        : const SizedBox.shrink(),
              ),

              // List Layanan
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.services.isEmpty) {
                  return EmptyStateWidget(
                    onAddPressed: () => showForm.value = true,
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.services.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final service = controller.services[index];
                    return ServiceCardWidget(
                      service: service,
                      onEdit: () => showEditForm(service),
                      onDelete:
                          () => confirmDelete(
                            service,
                          ), // Pass the entire service object
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
