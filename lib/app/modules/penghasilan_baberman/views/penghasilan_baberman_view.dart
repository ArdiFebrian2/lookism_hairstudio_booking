import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/penghasilan_baberman_controller.dart';

class PenghasilanBabermanView extends GetView<PenghasilanBabermanController> {
  const PenghasilanBabermanView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PenghasilanBabermanView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PenghasilanBabermanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
