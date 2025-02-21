import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wastewise/app/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Menyimpan data user secara lengkap
  var user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      final userDoc =
      await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (userDoc.exists) {
        user.value = UserModel.fromMap(userDoc.id, userDoc.data()!);
      } else {
        // Jika data user belum lengkap, set default
        user.value = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? 'No Email',
          username: 'username',
          fullName: 'Nama Lengkap',
          dateOfBirth: null,
        );
      }
    }
  }

  Future<void> updateUserProfile({
    required String fullName,
    required String username,
    DateTime? dateOfBirth,
  }) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      final userDocRef = _firestore.collection('users').doc(firebaseUser.uid);
      await userDocRef.update({
        'fullName': fullName,
        'username': username,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
      });
      // Update data lokal
      user.value = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        username: username,
        fullName: fullName,
        dateOfBirth: dateOfBirth,
      );
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Get.offAllNamed('/login');
  }
}
