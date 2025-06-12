import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_admin_controller.dart';

class ProfileAdminView extends GetView<ProfileAdminController> {
  const ProfileAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ProfileAdminController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Admin'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // Avatar dan info admin
              Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.indigo,
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => Text(
                      controller.adminName.value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Administrator Sistem',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),

              const Spacer(),

              // Tombol logout
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
