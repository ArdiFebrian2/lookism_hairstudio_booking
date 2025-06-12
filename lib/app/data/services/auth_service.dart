import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lookism_hairstudio_booking/app/data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  Future<String?> registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user?.uid;

    if (uid != null) {
      final userModel = UserModel(
        uid: uid,
        name: name,
        email: email,
        phone: phone,
        role: role,
      );

      await users.doc(uid).set(userModel.toJson());
    }

    return uid;
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }
}
