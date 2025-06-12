import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_barber_controller.dart';

class HomeBarberView extends GetView<HomeBarberController> {
  const HomeBarberView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeBarberView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HomeBarberView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
