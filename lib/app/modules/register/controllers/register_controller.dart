import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final email = ''.obs;
  final password = ''.obs;

  Future<void> register() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

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
