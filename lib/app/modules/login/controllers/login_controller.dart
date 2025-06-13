import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final isHidePassword = true.obs;
  final isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void login() async {
    isLoading.value = true;

    final email = emailC.text.trim();
    final password = passwordC.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email dan password tidak boleh kosong");
      isLoading.value = false;
      return;
    }

    try {
      // 🔐 Login ke Firebase Auth
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      // 📥 Ambil data user dari Firestore
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        Get.snackbar("Error", "Akun tidak ditemukan di database");
        isLoading.value = false;
        return;
      }

      final role = userDoc.data()!['role'];

      // 🌐 Arahkan berdasarkan role
      if (role == 'customer') {
        Get.offAllNamed('/navbar-customer');
      } else if (role == 'baberman') {
        Get.offAllNamed('/home-barber');
      } else if (role == 'admin') {
        Get.offAllNamed('/navbar-admin');
      } else {
        Get.snackbar("Error", "Role tidak dikenali");
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Gagal", e.message ?? "Terjadi kesalahan saat login");
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }
}
