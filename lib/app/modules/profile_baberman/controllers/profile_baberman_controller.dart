import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileBabermanController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = true.obs;
  var userData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final uid = currentUser.uid;
        final doc = await _firestore.collection("users").doc(uid).get();

        if (doc.exists) {
          userData.value = doc.data()!;
        }
      }
    } catch (e) {
      print("Error fetching user: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
