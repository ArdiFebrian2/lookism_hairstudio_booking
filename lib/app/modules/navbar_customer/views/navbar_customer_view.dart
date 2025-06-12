import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/modules/booking/views/booking_view.dart';
import 'package:lookism_hairstudio_booking/app/modules/layanan/views/layanan_view.dart';
import 'package:lookism_hairstudio_booking/app/modules/pemesanan/views/pemesanan_view.dart';
import 'package:lookism_hairstudio_booking/app/modules/riwayat/views/riwayat_view.dart';

import '../controllers/navbar_customer_controller.dart';

class NavbarCustomerView extends GetView<NavbarCustomerController> {
  const NavbarCustomerView({super.key});

  final List<Widget> _pages = const [
    LayananView(),
    BookingView(),
    PemesananView(),
    RiwayatView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _pages[controller.currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.design_services),
              label: 'Layanan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Booking',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.payments), label: 'Bayar'),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Riwayat',
            ),
          ],
        ),
      ),
    );
  }
}
