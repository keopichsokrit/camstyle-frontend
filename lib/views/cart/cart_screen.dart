import 'package:flutter/material.dart';
import '../../controllers/cart_controller.dart';
import '../../models/cart_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // --- LOGIC PRESERVED ---
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
  // -----------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor; // Luxury Gold
    final scaffoldBg = theme.scaffoldBackgroundColor; // Midnight Black

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "MY CART",
          style: TextStyle(
            color: primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [theme.colorScheme.surface.withOpacity(0.1), scaffoldBg],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<CartModel?>(
            future: _cartFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: primaryColor));
              }

              final cart = snapshot.data;
              if (cart == null || cart.items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, size: 80, color: theme.dividerColor.withOpacity(0.2)),
                      const SizedBox(height: 20),
                      Text(
                        "Your cart is empty",
                        style: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: theme.cardColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            // leading: ClipRRect(
                            //   borderRadius: BorderRadius.circular(10),
                            //   child: (item.product.images.isNotEmpty)
                            //       ? Image.network(item.product.images[0], width: 60, height: 60, fit: BoxFit.cover)
                            //       : Container(
                            //           width: 60,
                            //           height: 60,
                            //           color: theme.dividerColor.withOpacity(0.1),
                            //           child: Icon(Icons.image_not_supported, color: primaryColor),
                            //         ),
                            // ),
                            title: Text(
                              item.product.name.toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "Qty: ${item.quantity}",
                                style: TextStyle(color: theme.hintColor),
                              ),
                            ),
                            trailing: Text(
                              "\$${(item.product.price * item.quantity).toStringAsFixed(2)}",
                              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  _buildCheckoutArea(cart, theme, primaryColor, scaffoldBg),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutArea(CartModel cart, ThemeData theme, Color primaryColor, Color scaffoldBg) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: scaffoldBg,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TOTAL AMOUNT",
                style: TextStyle(color: theme.hintColor, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
              Text(
                "\$${cart.totalAmount.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => CartController.clearCart(context, _loadCart),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    foregroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("CLEAR", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => CartController.payNow(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: scaffoldBg,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "PAY NOW",
                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
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