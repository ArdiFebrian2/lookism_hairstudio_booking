import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_admin/views/home_admin_view.dart';
// import 'package:lookism_hairstudio_booking/app/modules/laporan/views/laporan_view.dart';
import 'package:lookism_hairstudio_booking/app/modules/profile_admin/views/profile_admin_view.dart';
import 'package:lookism_hairstudio_booking/app/modules/report/views/report_view.dart';
import 'package:lookism_hairstudio_booking/app/modules/review_customer/views/review_customer_view.dart';

import '../controllers/navbar_admin_controller.dart';

class NavbarAdminView extends GetView<NavbarAdminController> {
  const NavbarAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeAdminView(),
      const ReviewCustomerView(),
      ReportView(),
      const ProfileAdminView(),
    ];

    return Obx(
      () => Scaffold(
        body: pages[controller.currentIndex.value],
        bottomNavigationBar: Container(
          height: 72,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long),
                label: 'Review',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Laporan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
