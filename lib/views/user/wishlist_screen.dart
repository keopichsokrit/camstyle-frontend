import 'package:flutter/material.dart';
import '../../controllers/wishlist_controller.dart';
import '../../models/product_model.dart';
import '../../core/routes/app_routes.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  // --- LOGIC PRESERVED ---
  List<ProductModel> _wishlistItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWishlist();
  }

  Future<void> _fetchWishlist() async {
    final items = await WishlistController.getWishlist();
    setState(() {
      _wishlistItems = items;
      _isLoading = false;
    });
  }
  // -----------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor; // Your Gold
    final scaffoldBg = theme.scaffoldBackgroundColor; // Your Black

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "MY WISHLIST",
          style: TextStyle(
            color: primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [
              theme.colorScheme.surface.withOpacity(0.1),
              scaffoldBg,
            ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? Center(child: CircularProgressIndicator(color: primaryColor))
              : _wishlistItems.isEmpty
                  ? _buildEmptyState(theme, primaryColor)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: _wishlistItems.length,
                      itemBuilder: (context, index) {
                        final product = _wishlistItems[index];
                        return _buildWishlistItem(context, product, theme, primaryColor);
                      },
                    ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, Color primaryColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: theme.dividerColor.withOpacity(0.2)),
          const SizedBox(height: 20),
          Text(
            "Your wishlist is empty",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.hintColor.withOpacity(0.5),
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItem(BuildContext context, ProductModel product, ThemeData theme, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(product.images[0]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            product.name.toUpperCase(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontSize: 14,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "\$${product.price}",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.favorite, color: Colors.redAccent),
            onPressed: () {
              // Note: Logic for removal is usually handled in the controller
              // Leaving this as an icon for now as per your original code
            },
          ),
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.productDetail,
            arguments: product,
          ),
        ),
      ),
    );
  }
}