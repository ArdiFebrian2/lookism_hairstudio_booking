import 'package:get/get.dart';

import '../controllers/admin_validate_controller.dart';

class AdminValidateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminValidateController>(
      () => AdminValidateController(),
    );
  }
}
