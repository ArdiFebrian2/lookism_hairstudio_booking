import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final RxBool isHidePassword = true.obs;
  final RxBool isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void togglePasswordVisibility() {
    isHidePassword.value = !isHidePassword.value;
  }

  Future<void> login() async {
    final email = emailC.text.trim();
    final password = passwordC.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showCustomSnackbar(
        title: "Error",
        message: "Email dan password tidak boleh kosong.",
        icon: Icons.warning_amber_rounded,
        bgColor: Colors.redAccent,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Login ke Firebase Auth
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        showCustomSnackbar(
          title: "Error",
          message: "Akun tidak ditemukan di database.",
          icon: Icons.error_outline,
          bgColor: Colors.redAccent,
        );
        await _auth.signOut();
        return;
      }

      final data = userDoc.data()!;
      final role = data['role'];
      final status = data['status'] ?? 'pending';

      // Cek status akun customer
      if (role == 'customer' && status != 'approved') {
        showCustomSnackbar(
          title: "Login Ditolak",
          message: "Akun Anda masih menunggu persetujuan admin.",
          icon: Icons.hourglass_empty_rounded,
          bgColor: Colors.orangeAccent,
        );
        await _auth.signOut();
        return;
      }

      // Navigasi berdasarkan role
      switch (role) {
        case 'customer':
          Get.offAllNamed('/navbar-customer');
          break;
        case 'baberman':
          Get.offAllNamed('/navbar-baberman');
          break;
        case 'admin':
          Get.offAllNamed('/navbar-admin');
          break;
        default:
          showCustomSnackbar(
            title: "Error",
            message: "Role tidak dikenali.",
            icon: Icons.help_outline,
            bgColor: Colors.redAccent,
          );
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          showCustomSnackbar(
            title: "Password Salah",
            message: "Silakan periksa kembali password Anda.",
            icon: Icons.lock_outline,
            bgColor: Colors.orangeAccent,
          );
          break;
        case 'user-not-found':
          showCustomSnackbar(
            title: "Email Tidak Ditemukan",
            message: "Silakan periksa kembali email Anda.",
            icon: Icons.email_outlined,
            bgColor: Colors.orangeAccent,
          );
          break;
        case 'invalid-email':
          showCustomSnackbar(
            title: "Email Tidak Valid",
            message: "Masukkan email dengan format yang benar.",
            icon: Icons.alternate_email,
            bgColor: Colors.orangeAccent,
          );
          break;
        case 'too-many-requests':
          showCustomSnackbar(
            title: "Terlalu Banyak Percobaan",
            message: "Coba lagi nanti atau reset password Anda.",
            icon: Icons.lock_clock,
            bgColor: Colors.orangeAccent,
          );
          break;
        default:
          showCustomSnackbar(
            title: "Login Gagal",
            message: e.message ?? "Terjadi kesalahan saat login.",
            icon: Icons.error_outline,
            bgColor: Colors.redAccent,
          );
      }
    } catch (e) {
      showCustomSnackbar(
        title: "Error",
        message: "Terjadi kesalahan: $e",
        icon: Icons.error_outline,
        bgColor: Colors.redAccent,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showCustomSnackbar({
    required String title,
    required String message,
    required IconData icon,
    Color bgColor = Colors.redAccent,
  }) {
    Get.snackbar(
      title,
      message,
      icon: Icon(icon, color: Colors.white, size: 28),
      snackPosition: SnackPosition.TOP,
      backgroundColor: bgColor.withOpacity(0.95),
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 500),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }
}
