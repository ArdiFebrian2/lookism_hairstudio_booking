import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/data/models/service_model.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/controllers/service_controller.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/widgets/service_form_widget.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/widgets/service_card_widget.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/widgets/empty_state_widget.dart';

class ServiceView extends StatelessWidget {
  final ServiceController controller = Get.put(ServiceController());
  final RxBool showForm = false.obs;

  ServiceView({super.key});

  void deleteServiceWithoutDialog(ServiceModel service) async {
    final name = service.name;
    final onSuccess = () {
      Get.snackbar(
        'Berhasil',
        'Layanan "$name" berhasil dihapus.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    };

    if (service.id?.isNotEmpty == true) {
      await controller.deleteService(service.id!, onSuccess: onSuccess);
    } else {
      await controller.deleteServiceByName(name, onSuccess: onSuccess);
    }
  }

  void showEditForm(ServiceModel service) {
    Get.bottomSheet(
      ServiceFormWidget(
        isEdit: true,
        editingService: service,
        onFormSubmitted: () {
          controller.fetchServices(showInactive: true);
          Get.back();
        },
        onFormCancelled: () => Get.back(),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.isLoading.value && controller.services.isEmpty) {
        controller.fetchServices(showInactive: true);
      }
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
              Obx(() {
                return ElevatedButton.icon(
                  onPressed: () => showForm.toggle(),
                  icon: Icon(showForm.value ? Icons.close : Icons.add),
                  label: Text(showForm.value ? 'Tutup' : 'Tambah Layanan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showForm.value ? Colors.grey : Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              Obx(() {
                return AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState:
                      showForm.value
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                  firstChild: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ServiceFormWidget(
                        isEdit: false,
                        onFormSubmitted: () {
                          showForm.value = false;
                          controller.fetchServices(showInactive: true);
                        },
                        onFormCancelled: () => showForm.value = false,
                      ),
                    ),
                  ),
                  secondChild: const SizedBox.shrink(),
                );
              }),
              const SizedBox(height: 16),
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
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final service = controller.services[index];
                    return ServiceCardWidget(
                      service: service,
                      onEdit: () => showEditForm(service),
                      onDelete: () => deleteServiceWithoutDialog(service),
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
