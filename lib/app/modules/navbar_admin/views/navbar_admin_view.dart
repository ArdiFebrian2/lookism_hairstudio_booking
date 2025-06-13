import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../controllers/navbar_admin_controller.dart';

class NavbarAdminView extends StatelessWidget {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );
  final NavbarAdminController navController = Get.put(NavbarAdminController());

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      // PersistentBottomNavBarItem(
      //   icon: Icon(Icons.dashboard_outlined),
      //   title: ("Dashboard"),
      //   activeColorPrimary: Colors.deepPurple,
      //   activeColorSecondary: Colors.white,
      //   inactiveColorPrimary: Colors.grey,
      // ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.manage_accounts),
        title: ("Manajemen"),
        activeColorPrimary: Colors.deepPurple,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.receipt_long),
        title: ("Pemesanan"),
        activeColorPrimary: Colors.deepPurple,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.bar_chart),
        title: ("Laporan"),
        activeColorPrimary: Colors.deepPurple,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person_2),
        title: ("Profile"),
        activeColorPrimary: Colors.deepPurple,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: navController.screens,
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarHeight: 60,
      navBarStyle: NavBarStyle.style10, // Ganti sesuai selera: style1 - style18
    );
  }
}
