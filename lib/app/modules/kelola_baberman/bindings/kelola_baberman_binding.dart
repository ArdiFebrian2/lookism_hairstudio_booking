import 'package:get/get.dart';

import '../controllers/kelola_baberman_controller.dart';

class KelolaBabermanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KelolaBabermanController>(
      () => KelolaBabermanController(),
    );
  }
}
