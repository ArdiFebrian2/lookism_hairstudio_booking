import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileCustomerController extends GetxController {
  final username = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUsername();
  }

  void loadUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (doc.exists &&
            doc.data() != null &&
            doc.data()!.containsKey('name')) {
          username.value = doc['name'];
        } else {
          username.value = user.email ?? 'Pengguna';
        }
      } catch (e) {
        username.value = 'Pengguna';
        print('Error loading username: $e');
      }
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/login');
  }
}
