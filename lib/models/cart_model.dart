import 'product_model.dart';

class CartItem {
  final ProductModel product;
  final int quantity;

  CartItem({required this.product, required this.quantity});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      // Safely parse the product object sent from Node.js
      product: ProductModel.fromJson(json['product'] ?? {}),
      quantity: json['quantity'] ?? 0,
    );
  }
}

class CartModel {
  final String id;
  final List<CartItem> items;
  final double totalAmount;

  CartModel({required this.id, required this.items, required this.totalAmount});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['_id'] ?? '',
      // Ensure we always have a double for the price
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      items: json['items'] != null
          ? (json['items'] as List).map((i) => CartItem.fromJson(i)).toList()
          : [],
    );
  }
}