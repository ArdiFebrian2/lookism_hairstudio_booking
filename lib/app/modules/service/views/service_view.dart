import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/data/models/service_model.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/controllers/service_controller.dart';

class ServiceView extends StatelessWidget {
  final ServiceController controller = Get.put(ServiceController());

  ServiceView({super.key});

  final _formKey = GlobalKey<FormState>();
  final nameC = TextEditingController();
  final descC = TextEditingController();
  final priceC = TextEditingController();
  final durationC = TextEditingController();
  final isActive = true.obs;
  final isEdit = false.obs;
  final editingId = RxnString();
  final editingCreatedAt = Rxn<DateTime>();

  void resetForm() {
    nameC.clear();
    descC.clear();
    priceC.clear();
    durationC.clear();
    isActive.value = true;
    isEdit.value = false;
    editingId.value = null;
    editingCreatedAt.value = null;
  }

  void handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final service = ServiceModel(
      id: editingId.value,
      name: nameC.text,
      description: descC.text,
      price: double.tryParse(priceC.text) ?? 0.0,
      duration: int.tryParse(durationC.text) ?? 0,
      isActive: isActive.value,
      createdAt: editingCreatedAt.value ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (isEdit.value) {
      controller.updateService(service);
    } else {
      controller.addService(service);
    }

    resetForm();
  }

  void setEdit(ServiceModel s) {
    nameC.text = s.name;
    descC.text = s.description;
    priceC.text = s.price.toString();
    durationC.text = s.duration.toString();
    isActive.value = s.isActive;
    isEdit.value = true;
    editingId.value = s.id;
    editingCreatedAt.value = s.createdAt;
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchServices(showInactive: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Layanan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.services.isEmpty) {
                return const Text('Belum ada layanan');
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.services.length,
                itemBuilder: (context, index) {
                  final service = controller.services[index];
                  return Card(
                    child: ListTile(
                      title: Text(service.name),
                      subtitle: Text(
                        'Rp${service.price.toStringAsFixed(0)} • ${service.duration} menit',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => setEdit(service),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed:
                                () => controller.deleteService(service.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
            const SizedBox(height: 24),
            Obx(
              () => Text(
                isEdit.value ? 'Edit Layanan' : 'Tambah Layanan',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameC,
                    decoration: const InputDecoration(
                      labelText: 'Nama Layanan',
                    ),
                    validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: descC,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                    maxLines: 2,
                  ),
                  TextFormField(
                    controller: priceC,
                    decoration: const InputDecoration(labelText: 'Harga'),
                    keyboardType: TextInputType.number,
                    validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: durationC,
                    decoration: const InputDecoration(
                      labelText: 'Durasi (menit)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  Obx(
                    () => SwitchListTile(
                      title: const Text('Aktifkan Layanan'),
                      value: isActive.value,
                      onChanged: (val) => isActive.value = val,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: handleSubmit,
                          child: Obx(
                            () => Text(
                              isEdit.value ? 'Simpan Perubahan' : 'Tambah',
                            ),
                          ),
                        ),
                      ),
                      if (isEdit.value) ...[
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: resetForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          child: const Text('Batal'),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
