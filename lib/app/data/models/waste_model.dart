class WasteModel {
  String? id;
  String userId; // Field untuk menyimpan ID user
  String type;   // organik, plastik, kertas, dsb
  double amount; // berat / volume
  DateTime date; // tanggal pencatatan

  // === Tambahan koordinat ===
  double? latitude;
  double? longitude;

  WasteModel({
    this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.date,
    this.latitude,
    this.longitude,
  });

  // Konversi ke Map (untuk Firestore)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Membuat instance dari Firestore Document
  factory WasteModel.fromMap(String id, Map<String, dynamic> data) {
    return WasteModel(
      id: id,
      userId: data['userId'] ?? '',
      type: data['type'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      date: DateTime.parse(data['date'] ?? DateTime.now().toIso8601String()),

      // baca latitude & longitude, jika ada
      latitude: (data['latitude'] != null)
          ? (data['latitude'] as num).toDouble()
          : null,
      longitude: (data['longitude'] != null)
          ? (data['longitude'] as num).toDouble()
          : null,
    );
  }
}
