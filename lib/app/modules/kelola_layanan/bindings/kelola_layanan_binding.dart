import 'package:get/get.dart';

import '../controllers/kelola_layanan_controller.dart';

class KelolaLayananBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KelolaLayananController>(
      () => KelolaLayananController(),
    );
  }
}
