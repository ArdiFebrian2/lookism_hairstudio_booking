import 'package:get/get.dart';

class NavbarCustomerController extends GetxController {
  // Index tab yang sedang aktif
  var currentIndex = 0.obs;

  // Ubah tab saat pengguna memilih navigasi
  void changeTab(int index) {
    currentIndex.value = index;
  }
}
