import 'package:flutter/material.dart';
import '../../controllers/cart_controller.dart';
import '../../models/cart_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<CartModel?> _cartFuture;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  void _loadCart() {
    setState(() {
      _cartFuture = CartController.getCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart"), centerTitle: true),
      body: FutureBuilder<CartModel?>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final cart = snapshot.data;
          if (cart == null || cart.items.isEmpty) {
            return const Center(child: Text("Your cart is empty"));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Card(
                      child: ListTile(
                        // SAFETY CHECK: Don't show image if list is empty
                        // leading: (item.product.images.isNotEmpty)
                        //     ? Image.network(item.product.images[0], width: 50, fit: BoxFit.cover)
                        //     : const Icon(Icons.image_not_supported, size: 50),
                        title: Text(item.product.name),
                        subtitle: Text("Qty: ${item.quantity}"),
                        trailing: Text(
                          "\$${(item.product.price * item.quantity).toStringAsFixed(2)}",
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildCheckoutArea(cart),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCheckoutArea(CartModel cart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total:", style: TextStyle(fontSize: 18)),
              Text(
                "\$${cart.totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => CartController.clearCart(context, _loadCart),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text("CLEAR"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => CartController.payNow(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text(
                    "PAY NOW",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
