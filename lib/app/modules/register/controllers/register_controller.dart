import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observables
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final fullName = ''.obs;
  final username = ''.obs;
  final dateOfBirth = Rxn<DateTime>();

  // Metode register (Email & Password)
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
      Get.snackbar('Error', "email telah terdaftar");
    }
  }

  // Metode register dengan Google
  Future<void> registerWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // Jika user batal pilih akun
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Buat credential untuk Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in ke Firebase dengan credential
      final userCredential = await _auth.signInWithCredential(credential);
      final uid = userCredential.user!.uid;
      final userEmail = userCredential.user!.email ?? '';

      // Cek apakah user doc sudah ada di Firestore
      final userDoc = _firestore.collection('users').doc(uid);
      final userSnap = await userDoc.get();

      if (!userSnap.exists) {
        // Jika belum ada, buat doc baru
        await userDoc.set({
          'email': userEmail,
          'fullName': fullName.value,
          'username': username.value,
          'dateOfBirth': dateOfBirth.value?.toIso8601String(),
        });
      } else {
        // Jika sudah ada, update data (opsional)
        await userDoc.update({
          'fullName': fullName.value,
          'username': username.value,
          'dateOfBirth': dateOfBirth.value?.toIso8601String(),
        });
      }

      // Simpan sesi
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Navigasi ke home
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Navigasi ke Login
  void navigateToLogin() {
    Get.toNamed('/login');
  }
}
