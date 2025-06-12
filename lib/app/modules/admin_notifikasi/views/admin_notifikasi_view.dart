import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_notifikasi_controller.dart';

class AdminNotifikasiView extends GetView<AdminNotifikasiController> {
  const AdminNotifikasiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminNotifikasiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AdminNotifikasiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
