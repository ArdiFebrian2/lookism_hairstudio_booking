import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/data/models/service_model.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/controllers/service_controller.dart';

class ServiceFormWidget extends StatefulWidget {
  final VoidCallback? onFormSubmitted;
  final VoidCallback? onFormCancelled;
  final ServiceModel? editingService;

  const ServiceFormWidget({
    super.key,
    this.onFormSubmitted,
    this.onFormCancelled,
    this.editingService,
    required bool isEdit,
  });

  @override
  State<ServiceFormWidget> createState() => _ServiceFormWidgetState();
}

class _ServiceFormWidgetState extends State<ServiceFormWidget> {
  final ServiceController controller = Get.find<ServiceController>();
  final _formKey = GlobalKey<FormState>();
  final nameC = TextEditingController();
  final descC = TextEditingController();
  final priceC = TextEditingController();
  final durationC = TextEditingController();
  final isActive = true.obs;
  final isEdit = false.obs;
  String? editingId;
  DateTime? editingCreatedAt;

  @override
  void initState() {
    super.initState();
    if (widget.editingService != null) {
      _setEditData(widget.editingService!);
    }
  }

  void _setEditData(ServiceModel service) {
    nameC.text = service.name;
    descC.text = service.description;
    priceC.text = service.price.toString();
    durationC.text = service.duration.toString();
    isActive.value = service.isActive;
    isEdit.value = true;
    editingId = service.id;
    editingCreatedAt = service.createdAt;
  }

  void _resetForm() {
    nameC.clear();
    descC.clear();
    priceC.clear();
    durationC.clear();
    isActive.value = true;
    isEdit.value = false;
    editingId = null;
    editingCreatedAt = null;
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final service = ServiceModel(
      id: editingId,
      name: nameC.text,
      description: descC.text,
      price: double.tryParse(priceC.text) ?? 0.0,
      duration: int.tryParse(durationC.text) ?? 0,
      isActive: isActive.value,
      createdAt: editingCreatedAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (isEdit.value) {
      controller.updateService(service);
    } else {
      controller.addService(service);
    }

    _resetForm();
    widget.onFormSubmitted?.call();

    Get.snackbar(
      'Berhasil',
      isEdit.value
          ? 'Layanan berhasil diperbarui'
          : 'Layanan berhasil ditambahkan',
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      icon: const Icon(Icons.check_circle, color: Colors.green),
    );
  }

  void _handleCancel() {
    _resetForm();
    widget.onFormCancelled?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              isEdit.value ? 'Edit Layanan' : 'Tambah Layanan Baru',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: nameC,
                  label: 'Nama Layanan',
                  icon: Icons.content_cut,
                  validator:
                      (val) => val!.isEmpty ? 'Nama layanan wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: descC,
                  label: 'Deskripsi Layanan',
                  icon: Icons.description,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: priceC,
                        label: 'Harga (Rp)',
                        icon: Icons.attach_money,
                        keyboardType: TextInputType.number,
                        validator:
                            (val) => val!.isEmpty ? 'Harga wajib diisi' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: durationC,
                        label: 'Durasi (menit)',
                        icon: Icons.access_time,
                        keyboardType: TextInputType.number,
                        validator:
                            (val) => val!.isEmpty ? 'Durasi wajib diisi' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: SwitchListTile(
                      title: const Text('Aktifkan Layanan'),
                      subtitle: Text(
                        isActive.value
                            ? 'Layanan akan tersedia untuk booking'
                            : 'Layanan tidak tersedia',
                        style: TextStyle(
                          color: isActive.value ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                      value: isActive.value,
                      onChanged: (val) => isActive.value = val,
                      activeColor: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Obx(
                          () => Text(
                            isEdit.value
                                ? 'Simpan Perubahan'
                                : 'Tambah Layanan',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _handleCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Batal'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  @override
  void dispose() {
    nameC.dispose();
    descC.dispose();
    priceC.dispose();
    durationC.dispose();
    super.dispose();
  }
}
