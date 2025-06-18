import 'package:get/get.dart';

import '../controllers/review_customer_controller.dart';

class ReviewCustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewCustomerController>(
      () => ReviewCustomerController(),
    );
  }
}
