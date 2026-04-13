class SizeModel {
  final String id;
  final String sizeValue;

  SizeModel({required this.id, required this.sizeValue});

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      id: json['_id'] ?? '',
      sizeValue: json['sizeValue'] ?? '',
    );
  }
}