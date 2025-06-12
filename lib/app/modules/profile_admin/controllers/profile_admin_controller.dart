import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileAdminController extends GetxController {
  final adminName = 'Admin'.obs;

  @override
  void onInit() {
    super.onInit();
    loadAdminName();
  }

  void loadAdminName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      adminName.value = user.displayName ?? user.email ?? 'Admin';
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/login');
  }
}
