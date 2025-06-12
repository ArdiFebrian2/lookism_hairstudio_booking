import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/riwayat_controller.dart';

class RiwayatView extends GetView<RiwayatController> {
  const RiwayatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RiwayatView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RiwayatView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
