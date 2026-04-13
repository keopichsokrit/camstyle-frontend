class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String status;
  final double amount;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.status,
    required this.amount,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      status: json['status'] ?? 'info',
      amount: (json['amount'] ?? 0).toDouble(),
      isRead: json['isRead'] ?? false,
      // Parsing the timestamp from MongoDB Atlas
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']).toLocal() 
          : DateTime.now(),
    );
  }
}