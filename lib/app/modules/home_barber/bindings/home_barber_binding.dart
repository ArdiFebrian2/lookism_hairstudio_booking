import 'package:get/get.dart';

import '../controllers/home_barber_controller.dart';

class HomeBarberBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeBarberController>(
      () => HomeBarberController(),
    );
  }
}
