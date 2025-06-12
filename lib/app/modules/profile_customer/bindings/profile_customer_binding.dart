import 'package:get/get.dart';

import '../controllers/profile_customer_controller.dart';

class ProfileCustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileCustomerController>(
      () => ProfileCustomerController(),
    );
  }
}
