import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_customer/views/home_customer_view.dart';
import 'package:lookism_hairstudio_booking/app/modules/rating_customer/views/rating_customer_view.dart';
import 'package:lookism_hairstudio_booking/app/modules/riwayat/views/riwayat_view.dart';
import 'package:lookism_hairstudio_booking/app/modules/profile_customer/views/profile_customer_view.dart';

import '../controllers/navbar_customer_controller.dart';

class NavbarCustomerView extends GetView<NavbarCustomerController> {
  const NavbarCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeCustomerView(), // index 0
      const RiwayatView(),
      RatingCustomerView(), // index 1
      const ProfileCustomerView(),
      // index 2
    ];

    return Obx(
      () => Scaffold(
        body: pages[controller.currentIndex.value],
        bottomNavigationBar: Container(
          height: 72,
          decoration: BoxDecoration(
            color: Colors.deepPurple, // Ubah sesuai tema
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            selectedItemColor: Colors.grey,
            unselectedItemColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.design_services),
                label: 'Layanan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'Riwayat',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Rating'),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
