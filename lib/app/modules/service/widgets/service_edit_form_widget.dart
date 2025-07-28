import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/data/models/service_model.dart';
import 'package:lookism_hairstudio_booking/app/modules/service/controllers/service_controller.dart';

class ServiceEditFormWidget extends StatefulWidget {
  final ServiceModel service;
  final VoidCallback? onFormSubmitted;
  final VoidCallback? onFormCancelled;

  const ServiceEditFormWidget({
    super.key,
    required this.service,
    this.onFormSubmitted,
    this.onFormCancelled,
  });

  @override
  State<ServiceEditFormWidget> createState() => _ServiceEditFormWidgetState();
}

class _ServiceEditFormWidgetState extends State<ServiceEditFormWidget> {
  final ServiceController controller = Get.find<ServiceController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameC;
  late TextEditingController descC;
  late TextEditingController priceC;
  late TextEditingController durationC;
  late RxBool isActive;

  @override
  void initState() {
    super.initState();
    nameC = TextEditingController(text: widget.service.name);
    descC = TextEditingController(text: widget.service.description);
    priceC = TextEditingController(text: widget.service.price.toString());
    durationC = TextEditingController(text: widget.service.duration.toString());
    isActive = widget.service.isActive.obs;
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final updatedService = ServiceModel(
      name: nameC.text,
      description: descC.text,
      price: double.tryParse(priceC.text) ?? 0.0,
      duration: int.tryParse(durationC.text) ?? 0,
      isActive: isActive.value,
      createdAt: widget.service.createdAt,
      updatedAt: DateTime.now(),
    );

    controller.updateServiceByName(updatedService);
    widget.onFormSubmitted?.call();

    Get.snackbar(
      'Berhasil',
      'Layanan berhasil diperbarui',
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      icon: const Icon(Icons.check_circle, color: Colors.green),
    );
  }

  void _handleCancel() {
    widget.onFormCancelled?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Layanan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      onPressed: _handleCancel,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: nameC,
                        label: 'Nama Layanan',
                        icon: Icons.content_cut,
                        validator:
                            (val) =>
                                val!.isEmpty
                                    ? 'Nama layanan wajib diisi'
                                    : null,
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
                                  (val) =>
                                      val!.isEmpty ? 'Harga wajib diisi' : null,
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
                                  (val) =>
                                      val!.isEmpty
                                          ? 'Durasi wajib diisi'
                                          : null,
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
                                color:
                                    isActive.value ? Colors.green : Colors.red,
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Simpan Perubahan',
                                style: TextStyle(fontWeight: FontWeight.bold),
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
          ),
        ),
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
