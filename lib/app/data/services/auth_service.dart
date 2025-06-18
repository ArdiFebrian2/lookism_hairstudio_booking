import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lookism_hairstudio_booking/app/data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  /// Registrasi akun baru dan simpan ke Firestore
  Future<String?> registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
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
        return uid;
      }

      return null;
    } catch (e) {
      // Handle error sesuai kebutuhan (lempar ke UI, log, dsb.)
      rethrow;
    }
  }

  /// Login dengan email dan password
  Future<User?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Ambil user yang sedang login
  User? get currentUser => _auth.currentUser;

  /// Ambil user model dari Firestore
  Future<UserModel?> getUserModel() async {
    final uid = currentUser?.uid;
    if (uid == null) return null;

    final snapshot = await users.doc(uid).get();
    if (snapshot.exists) {
      return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }
}
