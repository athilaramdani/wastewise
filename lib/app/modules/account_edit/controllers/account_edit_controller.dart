import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wastewise/app/data/models/user_model.dart';

class AccountEditController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variabel reaktif untuk menampung data profile yang akan diedit
  var fullName = ''.obs;
  var username = ''.obs;
  var dateOfBirth = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      final userDoc =
      await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (userDoc.exists) {
        UserModel user = UserModel.fromMap(userDoc.id, userDoc.data()!);
        fullName.value = user.fullName;
        username.value = user.username;
        dateOfBirth.value = user.dateOfBirth;
      }
    }
  }

  Future<void> updateUserProfile() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      final userDocRef = _firestore.collection('users').doc(firebaseUser.uid);
      await userDocRef.set({
        'fullName': fullName.value,
        'username': username.value,
        'dateOfBirth': dateOfBirth.value?.toIso8601String(),
      }, SetOptions(merge: true));
      Get.offNamed('/account');
      Get.snackbar('Berhasil', 'Profil berhasil diperbarui');
    }
  }
}
