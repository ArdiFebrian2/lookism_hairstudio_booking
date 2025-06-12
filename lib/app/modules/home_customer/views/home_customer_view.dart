import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_customer_controller.dart';

class HomeCustomerView extends GetView<HomeCustomerController> {
  const HomeCustomerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeCustomerView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HomeCustomerView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
