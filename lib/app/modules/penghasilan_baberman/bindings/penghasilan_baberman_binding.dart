import 'package:get/get.dart';

import '../controllers/penghasilan_baberman_controller.dart';

class PenghasilanBabermanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PenghasilanBabermanController>(
      () => PenghasilanBabermanController(),
    );
  }
}
