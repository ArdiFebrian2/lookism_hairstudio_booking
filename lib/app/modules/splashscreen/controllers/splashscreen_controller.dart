import 'package:get/get.dart';

class SplashscreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print("SplashscreenController initialized");
    Future.delayed(Duration(seconds: 2), () {
      print("Navigating to /login");
      Get.offAllNamed('/login');
    });
  }
}
