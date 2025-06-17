import 'package:get/get.dart';

class NavbarBabermanController extends GetxController {
  // Index saat ini dari tab yang dipilih
  var currentIndex = 0.obs;

  // Method untuk mengubah tab
  void changeTab(int index) {
    currentIndex.value = index;
  }
}
