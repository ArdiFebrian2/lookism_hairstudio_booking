import 'package:get/get.dart';

import '../controllers/manajemen_controller.dart';

class ManajemenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManajemenController>(
      () => ManajemenController(),
    );
  }
}
