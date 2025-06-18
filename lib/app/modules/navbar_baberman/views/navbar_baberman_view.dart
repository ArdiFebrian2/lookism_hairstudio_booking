import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_barber/views/home_barber_view.dart';
import 'package:lookism_hairstudio_booking/app/modules/penghasilan_baberman/views/penghasilan_baberman_view.dart';
import 'package:lookism_hairstudio_booking/app/modules/profile_baberman/views/profile_baberman_view.dart';
import '../controllers/navbar_baberman_controller.dart';

class NavbarBabermanView extends GetView<NavbarBabermanController> {
  const NavbarBabermanView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = const [
      HomeBarberView(), // index 0
      PenghasilanBabermanView(), // index 1
      ProfileBabermanView(), // index 2
    ];

    return Obx(
      () => Scaffold(
        body: pages[controller.currentIndex.value],
        bottomNavigationBar: Container(
          height: 72,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
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
            selectedItemColor: Colors.grey.shade200,
            unselectedItemColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.design_services),
                label: 'Booking',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'Riwayat',
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
