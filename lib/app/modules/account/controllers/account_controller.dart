import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var userEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Ambil data user dari Firebase
    final user = _auth.currentUser;
    if (user != null) {
      userEmail.value = user.email ?? 'No Email';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    // Hapus sesi
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    // Arahkan ke Login
    Get.offAllNamed('/login');
  }
}
