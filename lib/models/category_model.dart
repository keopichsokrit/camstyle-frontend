class CategoryModel {
  final String id;
  final String name;
  final String? description;
  final List<String> image;

  CategoryModel({required this.id, required this.name, this.description, required this.image});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'] ?? '',
      image: List<String>.from(json['image'] ?? []),
    );
  }
}