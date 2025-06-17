import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_validate_controller.dart';

class AdminValidateView extends GetView<AdminValidateController> {
  const AdminValidateView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminValidateView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AdminValidateView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
