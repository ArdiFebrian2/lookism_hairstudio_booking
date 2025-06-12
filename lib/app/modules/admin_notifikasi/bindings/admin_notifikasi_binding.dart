import 'package:get/get.dart';

import '../controllers/admin_notifikasi_controller.dart';

class AdminNotifikasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminNotifikasiController>(
      () => AdminNotifikasiController(),
    );
  }
}
