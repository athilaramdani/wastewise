import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/waste_model.dart';
import '../../../data/providers/firebase_provider.dart';

class HomeController extends GetxController {
  final FirebaseProvider _firebaseProvider = FirebaseProvider();

  var wasteList = <WasteModel>[].obs;

  // username
  var userName = ''.obs;

  // Form input
  var wasteType = ''.obs;
  var wasteAmount = 0.0.obs;

  // Dark mode toggle
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserName();
    fetchWasteData();
  }

  Future<void> fetchWasteData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      var data = await _firebaseProvider.getWasteByUser(userId);
      wasteList.assignAll(data);
    }
  }

  Future<void> fetchUserName() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      userName.value = await _firebaseProvider.getUserName(userId);
    }
  }

  Future<void> addWaste() async {
    if (wasteType.isNotEmpty && wasteAmount.value > 0) {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      var waste = WasteModel(
        userId: userId,
        type: wasteType.value,
        amount: wasteAmount.value,
        date: DateTime.now(),
      );
      await _firebaseProvider.addWaste(waste);
      await fetchWasteData();
      clearInput();
    }
  }

  Future<void> updateWaste(WasteModel waste, String newType, double newAmount) async {
    waste.type = newType;
    waste.amount = newAmount;
    await _firebaseProvider.updateWaste(waste);
    await fetchWasteData();
  }

  Future<void> deleteWaste(String wasteId) async {
    await _firebaseProvider.deleteWaste(wasteId);
    await fetchWasteData();
  }

  void clearInput() {
    wasteType.value = '';
    wasteAmount.value = 0.0;
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    if (value) {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.light);
    }
  }
}
