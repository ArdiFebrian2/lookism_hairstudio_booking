import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_admin_controller.dart';

class HomeAdminView extends GetView<HomeAdminController> {
  const HomeAdminView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeAdminView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HomeAdminView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
