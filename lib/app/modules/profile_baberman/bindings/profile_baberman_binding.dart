import 'package:get/get.dart';

import '../controllers/profile_baberman_controller.dart';

class ProfileBabermanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileBabermanController>(
      () => ProfileBabermanController(),
    );
  }
}
