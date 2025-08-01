import 'package:get/get.dart';

import '../controllers/riwayat_baberman_controller.dart';

class RiwayatBabermanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiwayatBabermanController>(
      () => RiwayatBabermanController(),
    );
  }
}
