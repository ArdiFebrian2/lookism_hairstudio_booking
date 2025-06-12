import 'package:get/get.dart';

import '../controllers/home_customer_controller.dart';

class HomeCustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeCustomerController>(
      () => HomeCustomerController(),
    );
  }
}
