import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/size_controller.dart';
import '../../models/size_model.dart';
import '../../controllers/color_controller.dart';
import '../../models/color_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // --- LOGIC PRESERVED ---
  int _quantity = 1;
  List<SizeModel> _availableSizes = [];
  String _selectedSizeId = "";
  bool _isSizesLoading = true;
  List<ColorModel> _availableColors = [];
  String _selectedColorId = "";
  bool _isColorsLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        SizeController.getAllSizes(),
        ColorController.getAllColors(),
      ]);

      setState(() {
        _availableSizes = results[0] as List<SizeModel>;
        if (_availableSizes.isNotEmpty) _selectedSizeId = _availableSizes[0].id;
        _isSizesLoading = false;

        _availableColors = results[1] as List<ColorModel>;
        if (_availableColors.isNotEmpty) _selectedColorId = _availableColors[0].id;
        _isColorsLoading = false;
      });
    } catch (e) {
      setState(() {
        _isSizesLoading = false;
        _isColorsLoading = false;
      });
    }
  }

  Color _parseHexColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
        ],
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. PRODUCT HERO IMAGE
              Hero(
                tag: widget.product.id,
                child: Container(
                  height: 450,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(widget.product.images.isNotEmpty
                          ? widget.product.images[0]
                          : ""),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. HEADER INFO
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.name.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.product.category['name'] ?? "GENERAL",
                                style: TextStyle(
                                  color: primaryColor,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "\$${widget.product.price}",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                    _buildSectionTitle("Description"),
                    const SizedBox(height: 10),
                    Text(
                      widget.product.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor.withOpacity(0.7),
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 3. SIZE SELECTION
                    _buildSectionTitle("Select Size"),
                    const SizedBox(height: 15),
                    _isSizesLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Wrap(
                            spacing: 12,
                            children: _availableSizes.map((size) {
                              final isSelected = _selectedSizeId == size.id;
                              return ChoiceChip(
                                label: Text(size.sizeValue),
                                selected: isSelected,
                                selectedColor: primaryColor,
                                backgroundColor: theme.cardColor.withOpacity(0.1),
                                labelStyle: TextStyle(
                                  color: isSelected ? scaffoldBg : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onSelected: (selected) {
                                  setState(() => _selectedSizeId = size.id);
                                },
                              );
                            }).toList(),
                          ),

                    const SizedBox(height: 30),

                    // 4. COLOR SELECTION
                    _buildSectionTitle("Select Color"),
                    const SizedBox(height: 15),
                    _isColorsLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Wrap(
                            spacing: 20,
                            children: _availableColors.map((color) {
                              bool isSelected = _selectedColorId == color.id;
                              return GestureDetector(
                                onTap: () => setState(() => _selectedColorId = color.id),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? primaryColor : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: _parseHexColor(color.hexCode),
                                    child: isSelected
                                        ? Icon(Icons.check, size: 18, color: scaffoldBg)
                                        : null,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                    const SizedBox(height: 40),

                    // 5. QUANTITY SELECTOR
                    Row(
                      children: [
                        _buildSectionTitle("Quantity"),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              _buildQtyBtn(Icons.remove, _decrease, primaryColor),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "$_quantity",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              _buildQtyBtn(Icons.add, _increase, primaryColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100), // Space for bottom bar
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: scaffoldBg,
          border: Border(top: BorderSide(color: theme.dividerColor.withOpacity(0.1))),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: scaffoldBg,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 0,
          ),
          onPressed: widget.product.quantity > 0
              ? () => CartController.addToCart(
                  context: context, productId: widget.product.id, quantity: _quantity)
              : null,
          child: Text(
            widget.product.quantity > 0 ? "ADD TO CART" : "OUT OF STOCK",
            style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback action, Color primaryColor) {
    return IconButton(
      icon: Icon(icon, color: primaryColor, size: 20),
      onPressed: action,
    );
  }
}