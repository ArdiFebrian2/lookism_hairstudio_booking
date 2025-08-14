import 'package:get/get.dart';

import '../controllers/pending_customer_controller.dart';

class PendingCustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PendingCustomerController>(
      () => PendingCustomerController(),
    );
  }
}
