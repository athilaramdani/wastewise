import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/models/waste_model.dart';
import '../../../data/providers/firebase_provider.dart';

class HomeController extends GetxController {
  final FirebaseProvider _firebaseProvider = FirebaseProvider();

  // Waste current user
  var wasteList = <WasteModel>[].obs;
  // Waste dari user lain
  var otherWasteList = <WasteModel>[].obs;

  // Username
  var userName = ''.obs;

  // Form input observables
  var wasteType = ''.obs;
  var wasteAmount = 0.0.obs;

  // Tambahkan TextEditingController untuk form input
  final TextEditingController wasteTypeController = TextEditingController();
  final TextEditingController wasteAmountController = TextEditingController();

  // Koordinat user
  var currentLat = 0.0.obs;
  var currentLng = 0.0.obs;

  // Dark mode toggle
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserName();
    fetchWasteData();
    fetchAllWaste();
    _determinePosition(); // Ambil lokasi user saat init
  }

  Future<void> fetchWasteData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      var data = await _firebaseProvider.getWasteByUser(userId);
      wasteList.assignAll(data);
    }
  }

  Future<void> fetchAllWaste() async {
    var allData = await _firebaseProvider.getAllWaste();
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      otherWasteList.assignAll(allData.where((w) => w.userId != currentUserId));
    }
  }

  Future<void> fetchUserName() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      userName.value = await _firebaseProvider.getUserName(userId);
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentLat.value = position.latitude;
    currentLng.value = position.longitude;
  }

  Future<void> addWaste() async {
    if (wasteType.isNotEmpty && wasteAmount.value > 0) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar("Error", "User belum login. Silakan login terlebih dahulu.");
        return;
      }
      final userId = user.uid;
      var waste = WasteModel(
        userId: userId,
        type: wasteType.value,
        amount: wasteAmount.value,
        date: DateTime.now(),
        latitude: currentLat.value,
        longitude: currentLng.value,
      );
      try {
        await _firebaseProvider.addWaste(waste);
        await fetchWasteData();
        await fetchAllWaste();
        clearInput();
        Get.snackbar("Sukses", "Data sampah berhasil ditambahkan.");
      } catch (e) {
        Get.snackbar("Error", "Gagal menambahkan data sampah: $e");
      }
    } else {
      Get.snackbar("Error", "Pastikan jenis dan berat/volume sampah sudah terisi dengan benar.");
    }
  }

  Future<void> updateWaste(WasteModel waste, String newType, double newAmount) async {
    waste.type = newType;
    waste.amount = newAmount;
    await _firebaseProvider.updateWaste(waste);
    await fetchWasteData();
    await fetchAllWaste();
  }

  Future<void> deleteWaste(String wasteId) async {
    await _firebaseProvider.deleteWaste(wasteId);
    await fetchWasteData();
    await fetchAllWaste();
  }

  void clearInput() {
    wasteType.value = '';
    wasteAmount.value = 0.0;
    wasteTypeController.clear();
    wasteAmountController.clear();
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }
}
