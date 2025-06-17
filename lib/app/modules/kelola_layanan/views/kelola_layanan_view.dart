import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/kelola_layanan_controller.dart';

class KelolaLayananView extends GetView<KelolaLayananController> {
  const KelolaLayananView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KelolaLayananView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'KelolaLayananView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
