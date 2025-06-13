import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/kelola_baberman_controller.dart';

class KelolaBabermanView extends GetView<KelolaBabermanController> {
  const KelolaBabermanView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => KelolaBabermanController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Baberman'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.users.isEmpty) {
          return const Center(child: Text('Belum ada data Baberman.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.cut, color: Colors.white),
                ),
                title: Text(
                  user['nama'],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(user['alamat']), Text(user['telepon'])],
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showForm(context, user),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.deleteBaberman(user['uid']),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(context, null),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void _showForm(BuildContext context, Map<String, dynamic>? item) {
    final namaController = TextEditingController(text: item?['nama']);
    final alamatController = TextEditingController(text: item?['alamat']);
    final teleponController = TextEditingController(text: item?['telepon']);
    final emailController = TextEditingController(text: item?['email']);
    final passwordController = TextEditingController();

    final isEdit = item != null;

    Get.bottomSheet(
      SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          left: 20,
          right: 20,
          top: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEdit ? 'Edit Baberman' : 'Tambah Baberman',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: alamatController,
              decoration: const InputDecoration(labelText: 'Alamat'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: teleponController,
              decoration: const InputDecoration(labelText: 'Telepon'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8),
            if (!isEdit) ...[
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (namaController.text.isEmpty ||
                      alamatController.text.isEmpty ||
                      teleponController.text.isEmpty ||
                      (!isEdit &&
                          (emailController.text.isEmpty ||
                              passwordController.text.isEmpty))) {
                    Get.snackbar('Validasi', 'Semua field wajib diisi');
                    return;
                  }

                  final data = {
                    'nama': namaController.text,
                    'alamat': alamatController.text,
                    'telepon': teleponController.text,
                  };

                  if (isEdit) {
                    controller.updateBaberman(item['uid'], data);
                  } else {
                    controller.addBaberman(
                      nama: namaController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      alamat: alamatController.text,
                      telepon: teleponController.text,
                    );
                  }

                  Get.back(); // Tutup bottomSheet
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(isEdit ? 'Simpan Perubahan' : 'Tambah'),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}
