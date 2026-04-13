class LoginLogModel {
  final String id;
  final DateTime loginTime;
  final String? ipAddress;
  final String? device;

  LoginLogModel({
    required this.id,
    required this.loginTime,
    this.ipAddress,
    this.device,
  });

  factory LoginLogModel.fromJson(Map<String, dynamic> json) {
    return LoginLogModel(
      id: json['_id'],
      loginTime: DateTime.parse(json['loginTime']),
      ipAddress: json['ipAddress'],
      device: json['device'],
    );
  }
}