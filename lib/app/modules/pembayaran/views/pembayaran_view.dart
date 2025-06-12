import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pembayaran_controller.dart';

class PembayaranView extends GetView<PembayaranController> {
  const PembayaranView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PembayaranView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PembayaranView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
