import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/waste_model.dart';
import '../../../data/providers/firebase_provider.dart';

class HomeController extends GetxController {
  final FirebaseProvider _firebaseProvider = FirebaseProvider();

  var wasteList = <WasteModel>[].obs;

  // Form input
  var wasteType = ''.obs;
  var wasteAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWasteData();
  }

  Future<void> fetchWasteData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      var data = await _firebaseProvider.getWasteByUser(userId);
      wasteList.assignAll(data);
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
}
