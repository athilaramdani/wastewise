import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final fullName = ''.obs;
  final username = ''.obs;
  final dateOfBirth = Rxn<DateTime>();

  Future<void> register() async {
    if (password.value != confirmPassword.value) {
      Get.snackbar('Error', 'Password dan konfirmasi password tidak sama');
      return;
    }
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      // Buat dokumen user di Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email.value,
        'fullName': fullName.value,
        'username': username.value,
        'dateOfBirth': dateOfBirth.value?.toIso8601String(),
      });

      // Simpan sesi
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void navigateToLogin() {
    Get.toNamed('/login');
  }
}
