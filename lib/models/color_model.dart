class ColorModel {
  final String id;
  final String colorName;
  final String hexCode;

  ColorModel({required this.id, required this.colorName, required this.hexCode});

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      id: json['_id'] ?? '',
      colorName: json['colorName'] ?? '',
      hexCode: json['hexCode'] ?? '#FFFFFF',
    );
  }
}