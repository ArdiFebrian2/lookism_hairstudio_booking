import 'package:get/get.dart';

class NavbarCustomerController extends GetxController {
  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
