import 'package:get/get.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final RxBool isLoading = false.obs;

  Future<void> registerCustomer({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      final uid = await AuthService().registerWithEmail(
        name: name,
        email: email,
        phone: phone,
        password: password,
        role: 'customer',
      );

      if (uid != null) {
        Get.offAllNamed('/login');
        Get.snackbar('Berhasil', 'Akun berhasil dibuat');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await AuthService().login(email, password);
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Login Gagal', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
