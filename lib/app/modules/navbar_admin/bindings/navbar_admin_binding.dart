import 'package:get/get.dart';

import '../controllers/navbar_admin_controller.dart';

class NavbarAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavbarAdminController>(
      () => NavbarAdminController(),
    );
  }
}
