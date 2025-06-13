import 'package:get/get.dart';

import '../controllers/jadwal_baberman_controller.dart';

class JadwalBabermanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JadwalBabermanController>(
      () => JadwalBabermanController(),
    );
  }
}
