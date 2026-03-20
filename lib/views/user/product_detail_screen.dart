import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../controllers/cart_controller.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product; // Passed from the Home Screen grid

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _increase() {
    if (_quantity < widget.product.quantity) {
      setState(() => _quantity++);
    }
  }

  void _decrease() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. PRODUCT IMAGE (From Cloudinary)
            Hero(
              tag: widget.product.id,
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.product.images.isNotEmpty ? widget.product.images[0] : ""),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. PRICE & NAME
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\$${widget.product.price}", 
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                      Chip(label: Text(widget.product.category['name'] ?? "General")),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(widget.product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  
                  const SizedBox(height: 15),
                  
                  // 3. STOCK & DESCRIPTION
                  Text("Available Stock: ${widget.product.quantity}", 
                    style: TextStyle(color: widget.product.quantity > 0 ? Colors.grey : Colors.red)),
                  const Divider(height: 30),
                  const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(widget.product.description, style: const TextStyle(color: Colors.black54, fontSize: 16)),
                  
                  const SizedBox(height: 40),

                  // 4. QUANTITY SELECTOR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildQtyBtn(Icons.remove, _decrease),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text("$_quantity", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ),
                      _buildQtyBtn(Icons.add, _increase),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // 5. ADD TO CART BUTTON
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: widget.product.quantity > 0 
            ? () => CartController.addToCart(context: context, productId: widget.product.id, quantity: _quantity)
            : null,
          child: Text(widget.product.quantity > 0 ? "ADD TO CART" : "OUT OF STOCK"),
        ),
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback action) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      child: IconButton(icon: Icon(icon), onPressed: action),
    );
  }
}