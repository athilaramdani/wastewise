import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observables untuk menyimpan nilai textfield
  final email = ''.obs;
  final password = ''.obs;

  // Metode login Email/Password
  Future<void> login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );
      // Simpan sesi
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Navigasi ke home
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', "Email / Password salah");
    }
  }

  // Metode login dengan Google
  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // Jika user batal pilih akun
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Dapatkan credential dari GoogleSignIn
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in ke Firebase dengan credential
      await _auth.signInWithCredential(credential);

      // Simpan sesi
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Navigasi ke home
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Navigasi ke Register
  void navigateToRegister() {
    Get.toNamed('/register');
  }
}
