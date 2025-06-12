import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_customer_controller.dart';

class ProfileCustomerView extends GetView<ProfileCustomerController> {
  const ProfileCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<ProfileCustomerController>(() => ProfileCustomerController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // Avatar dan greeting
              Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => Text(
                      'Halo, ${controller.username.value} 👋',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Selamat datang di aplikasi kami!',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),

              const Spacer(), // Mengisi ruang kosong di tengah agar tombol di bawah
              // Logout button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 4,
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
