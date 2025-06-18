import 'package:get/get.dart';

import '../controllers/rating_customer_controller.dart';

class RatingCustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RatingCustomerController>(
      () => RatingCustomerController(),
    );
  }
}
