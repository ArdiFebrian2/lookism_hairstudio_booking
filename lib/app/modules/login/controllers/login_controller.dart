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
      Get.snackbar(
        "Error",
        "Email dan password tidak boleh kosong",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;

    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        Get.snackbar(
          "Error",
          "Akun tidak ditemukan di database",
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      final role = userDoc.data()!['role'];

      // Navigasi berdasarkan role
      if (role == 'customer') {
        Get.offAllNamed('/navbar-customer');
      } else if (role == 'baberman') {
        Get.offAllNamed('/navbar-baberman');
      } else if (role == 'admin') {
        Get.offAllNamed('/navbar-admin');
      } else {
        Get.snackbar(
          "Error",
          "Role tidak dikenali",
          snackPosition: SnackPosition.TOP,
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Gagal",
        e.message ?? "Terjadi kesalahan saat login",
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Terjadi kesalahan: $e",
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
