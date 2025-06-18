import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/manajemen_controller.dart';

class ManajemenView extends GetView<ManajemenController> {
  const ManajemenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Manajemen Data',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple[700],
        elevation: 0,
        shadowColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.withOpacity(0.1),
                  Colors.deepPurple.withOpacity(0.3),
                  Colors.deepPurple.withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // _buildHeader(),
            _buildMenuSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildMenuTile(
            icon: Icons.design_services_rounded,
            title: "Kelola Layanan",
            subtitle: "Tambah, ubah, hapus data layanan",
            gradient: [Colors.blue[400]!, Colors.blue[600]!],
            onTap: () {
              Get.toNamed('/service');
            },
          ),
          const SizedBox(height: 16),
          _buildMenuTile(
            icon: Icons.person_rounded,
            title: "Kelola Baberman",
            subtitle: "Tambah, ubah, hapus data baberman",
            gradient: [Colors.green[400]!, Colors.green[600]!],
            onTap: () {
              Get.toNamed('/kelola-baberman');
            },
          ),
          const SizedBox(height: 16),
          _buildMenuTile(
            icon: Icons.schedule_rounded,
            title: "Kelola Jadwal Baberman",
            subtitle: "Kelola jadwal & validasi bentrok",
            gradient: [Colors.orange[400]!, Colors.orange[600]!],
            onTap: () {
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
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Hero(
      tag: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[200]!, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradient,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: gradient[1].withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
