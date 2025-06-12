import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/modules/dashboard/views/dashboard_view.dart';
import 'package:lookism_hairstudio_booking/app/modules/laporan/views/laporan_view.dart';
import 'package:lookism_hairstudio_booking/app/modules/manajemen/views/manajemen_view.dart';
import 'package:lookism_hairstudio_booking/app/modules/pemesanan/views/pemesanan_view.dart';
import 'package:lookism_hairstudio_booking/app/modules/profile_admin/views/profile_admin_view.dart';

class NavbarAdminController extends GetxController {
  var selectedIndex = 0.obs;

  final List<Widget> screens = [
    DashboardView(),
    ManajemenView(),
    PemesananView(),
    LaporanView(),
    ProfileAdminView(),
  ];

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
