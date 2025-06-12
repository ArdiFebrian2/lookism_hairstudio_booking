import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/manajemen_controller.dart';

class ManajemenView extends GetView<ManajemenController> {
  const ManajemenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Data Manajemen'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuTile(
            icon: Icons.design_services,
            title: "Kelola Layanan",
            subtitle: "Tambah, ubah, hapus data layanan",
            onTap: () {
              // TODO: Navigasi ke CRUD Layanan
              Get.toNamed('/layanan');
            },
          ),
          const SizedBox(height: 16),
          _buildMenuTile(
            icon: Icons.person,
            title: "Kelola Baberman",
            subtitle: "Tambah, ubah, hapus data baberman",
            onTap: () {
              // TODO: Navigasi ke CRUD Baberman
              Get.toNamed('/baberman');
            },
          ),
          const SizedBox(height: 16),
          _buildMenuTile(
            icon: Icons.schedule,
            title: "Kelola Jadwal Baberman",
            subtitle: "Kelola jadwal & validasi bentrok",
            onTap: () {
              // TODO: Navigasi ke CRUD Jadwal Baberman
              Get.toNamed('/jadwal-baberman');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.shade100,
          child: Icon(icon, color: Colors.deepPurple),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }
}
