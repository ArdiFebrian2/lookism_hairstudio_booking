import 'package:get/get.dart';

import '../controllers/schedules_controller.dart';

class SchedulesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SchedulesController>(
      () => SchedulesController(),
    );
  }
}
