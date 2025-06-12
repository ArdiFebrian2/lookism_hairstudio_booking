import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pemesanan_controller.dart';

class PemesananView extends GetView<PemesananController> {
  const PemesananView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PemesananView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PemesananView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
