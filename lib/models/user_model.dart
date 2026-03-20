class UserModel {
  final String? id;
  final String name;
  final String email;
  final String role;
  final String? avatar;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
  });

  // Factory to create a user from the JSON returned by your backend
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      avatar: json['avatar'] ?? '',
    );
  }
}