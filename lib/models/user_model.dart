class UserModel {
  final String? id;
  final String name;
  final String email;
  final String role;
  final String? avatar;
  // --- NEW FIELDS ---
  final DateTime? birthdate;
  final String home;
  final String city;
  final String homeTown;
  final String phoneNumber;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
    this.birthdate,
    this.home = "",
    this.city = "",
    this.homeTown = "",
    this.phoneNumber = "",
  });

  // Factory to create a user from the JSON returned by your backend
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      avatar: json['avatar'] ?? '',
      // Parsing new fields
      birthdate: json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null,
      home: json['home'] ?? '',
      city: json['city'] ?? '',
      homeTown: json['homeTown'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
}