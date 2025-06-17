import 'package:get/get.dart';

import '../controllers/navbar_baberman_controller.dart';

class NavbarBabermanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavbarBabermanController>(
      () => NavbarBabermanController(),
    );
  }
}
