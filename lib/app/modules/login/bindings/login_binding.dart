import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/modules/login/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}
