import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/data/controller/auth_controller.dart';

class RegisterController extends GetxController {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final passwordC = TextEditingController();
  final isHidePassword = true.obs;
  final isLoading = false.obs;

  void registerCustomer() async {
    if (nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        phoneC.text.isNotEmpty &&
        passwordC.text.isNotEmpty) {
      await AuthController.to.registerCustomer(
        name: nameC.text.trim(),
        email: emailC.text.trim(),
        phone: phoneC.text.trim(),
        password: passwordC.text.trim(),
      );
    } else {
      Get.snackbar('Validasi', 'Harap isi semua data!');
    }
  }
}
