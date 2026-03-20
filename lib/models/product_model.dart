class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final dynamic category; 
  final List<String> images;
  final int quantity;

  ProductModel({
    required this.id, required this.name, required this.description,
    required this.price, required this.category, required this.images, required this.quantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      // Use ?? '' to prevent null errors if a field is missing in the Cart response
      id: json['_id'] ?? '', 
      name: json['name'] ?? 'No Name',
      description: json['description'] ?? '', 
      
      // Safety for price: handle potential nulls and force to double
      price: (json['price'] ?? 0).toDouble(),
      
      category: json['category'] ?? '', 
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      quantity: json['quantity'] ?? 0,
    );
  }
}