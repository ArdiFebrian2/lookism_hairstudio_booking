import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/controllers/service_controller.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/widgets/service_form_widget.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/widgets/service_card_widget.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/widgets/empty_state_widget.dart';

class ServiceView extends StatelessWidget {
  final ServiceController controller = Get.put(ServiceController());

  ServiceView({super.key});

  final showForm = false.obs;

  void confirmDelete(String serviceId, String serviceName) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus layanan "$serviceName"?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              controller.deleteService(serviceId);
              Get.back();
              Get.snackbar(
                'Berhasil',
                'Layanan berhasil dihapus',
                backgroundColor: Colors.red.shade100,
                colorText: Colors.red.shade800,
                icon: const Icon(Icons.delete, color: Colors.red),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchServices(showInactive: true);

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
        onRefresh: () async {
          controller.fetchServices(showInactive: true);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
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
                      onPressed: () {
                        showForm.value = !showForm.value;
                      },
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

              // Form section
              Obx(
                () => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: showForm.value ? null : 0,
                  child:
                      showForm.value
                          ? ServiceFormWidget(
                            onFormSubmitted: () => showForm.value = false,
                            onFormCancelled: () => showForm.value = false,
                          )
                          : const SizedBox(),
                ),
              ),

              // Services List
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
                      onEdit: () {
                        showForm.value = true;
                      },
                      onDelete: () => confirmDelete(service.id!, service.name),
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
