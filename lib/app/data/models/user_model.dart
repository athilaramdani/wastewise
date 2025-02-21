class UserModel {
  final String? id;
  final String email;
  final String username;
  final String fullName;
  final DateTime? dateOfBirth;

  UserModel({
    this.id,
    required this.email,
    required this.username,
    required this.fullName,
    this.dateOfBirth,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      fullName: data['fullName'] ?? '',
      dateOfBirth: data['dateOfBirth'] != null ? DateTime.parse(data['dateOfBirth']) : null,
    );
  }
}
