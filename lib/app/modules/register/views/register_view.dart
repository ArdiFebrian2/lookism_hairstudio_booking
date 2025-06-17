import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/data/controller/auth_controller.dart';
import 'package:lookism_hairstudio_booking/app/modules/login/controllers/login_controller.dart';
import 'package:lookism_hairstudio_booking/app/modules/login/views/login_view.dart';
import 'package:lookism_hairstudio_booking/app/modules/register/controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => RegisterController());
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Logo/Brand
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.content_cut,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 32),

                  // Header Text
                  Text(
                    "Buat Akun Baru",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Daftar untuk mulai booking dengan Lookism Hairstudio",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 40),

                  // Form Container
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Full Name Field
                        TextField(
                          controller: controller.nameC,
                          decoration: InputDecoration(
                            labelText: "Nama Lengkap",
                            hintText: "Masukkan nama Anda",
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.deepPurple,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                        SizedBox(height: 20),

                        // Email Field
                        TextField(
                          controller: controller.emailC,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "Masukkan email Anda",
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Colors.deepPurple,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                        SizedBox(height: 20),

                        // Phone Number Field
                        TextField(
                          controller: controller.phoneC,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Nomor HP",
                            hintText: "Masukkan nomor HP Anda",
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              color: Colors.deepPurple,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                        SizedBox(height: 20),

                        // Password Field
                        Obx(
                          () => TextField(
                            controller: controller.passwordC,
                            obscureText: controller.isHidePassword.value,
                            decoration: InputDecoration(
                              labelText: "Password",
                              hintText: "Masukkan password",
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.deepPurple,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isHidePassword.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey[600],
                                ),
                                onPressed:
                                    () => controller.isHidePassword.toggle(),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        // Register Button
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed:
                                  AuthController.to.isLoading.value
                                      ? null
                                      : controller.registerCustomer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                disabledBackgroundColor: Colors.grey[300],
                              ),
                              child:
                                  AuthController.to.isLoading.value
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : const Text(
                                        "Daftar",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Already Have Account Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sudah punya akun? ",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Pastikan controller sudah tersedia
                          if (Get.isRegistered<LoginController>()) {
                            Get.delete<
                              LoginController
                            >(); // hapus instance lama
                          }
                          Get.put(
                            LoginController(),
                          ); // inisialisasi ulang controller
                          Get.offAll(() => const LoginView());
                        },
                        child: const Text(
                          "Masuk",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
