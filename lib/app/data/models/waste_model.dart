class WasteModel {
  String? id;
  String userId; // Field baru untuk menyimpan ID user
  String type;   // organik, plastik, kertas, dsb
  double amount; // berat / volume
  DateTime date; // tanggal pencatatan

  WasteModel({
    this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.date,
  });

  // Konversi ke Map (untuk Firestore)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
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
    );
  }
}
