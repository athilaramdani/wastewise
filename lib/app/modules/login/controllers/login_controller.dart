import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Contoh text field controller
  final email = ''.obs;
  final password = ''.obs;

  Future<void> login() async {
    try {
      await _auth.signInWithEmailAndPassword(email: email.value, password: password.value);
      // Simpan sesi
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Navigasi ke home
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Contoh login dengan Google (belum dibuat)
  // Future<void> loginWithGoogle() async {
  //   // Implementasi Google SignIn
  // }

  void navigateToRegister() {
    Get.toNamed('/register');
  }
}
