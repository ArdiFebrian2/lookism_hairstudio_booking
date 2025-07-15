import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_customer/controllers/home_customer_controller.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_customer/widgets/custom_appbar.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_customer/widgets/service_section.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_customer/widgets/welcome_section.dart';

class HomeCustomerView extends GetView<HomeCustomerController> {
  const HomeCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    Get.put(HomeCustomerController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          CustomAppBar(),
          WelcomeSection(),
          ServicesSection(),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
