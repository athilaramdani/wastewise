import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/waste_model.dart';

class FirebaseProvider {
  final CollectionReference wasteCollection =
  FirebaseFirestore.instance.collection('waste_records');

  // Misal user disimpan di "users" collection:
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');

  Future<void> addWaste(WasteModel waste) async {
    await wasteCollection.add(waste.toMap());
  }

  // Ambil data sampah berdasarkan userId
  Future<List<WasteModel>> getWasteByUser(String userId) async {
    final querySnapshot =
    await wasteCollection.where('userId', isEqualTo: userId).get();
    return querySnapshot.docs
        .map((doc) =>
        WasteModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateWaste(WasteModel waste) async {
    if (waste.id != null) {
      await wasteCollection.doc(waste.id).update(waste.toMap());
    }
  }

  Future<void> deleteWaste(String wasteId) async {
    await wasteCollection.doc(wasteId).delete();
  }

  // =====================================================
  // BARU: Get userName
  // =====================================================
  Future<String> getUserName(String userId) async {
    final docRef = userCollection.doc(userId);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return data['username'] ?? 'UnknownUser';
    } else {
      return 'UnknownUser';
    }
  }
}
