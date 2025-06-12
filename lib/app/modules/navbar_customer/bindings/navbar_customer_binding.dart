import 'package:get/get.dart';

import '../controllers/navbar_customer_controller.dart';

class NavbarCustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavbarCustomerController>(
      () => NavbarCustomerController(),
    );
  }
}
