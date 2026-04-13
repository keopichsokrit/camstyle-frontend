import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import '../../controllers/product_controller.dart';
import '../../controllers/category_controller.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';
import '../../core/routes/app_routes.dart';
import '../../controllers/user_controller.dart';
import '../../models/user_model.dart';
import '../../core/utils/storage_helper.dart';
import '../../controllers/wishlist_controller.dart';
import '../../core/constrains/api_constants.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedCategoryId = "All";

  List<ProductModel> _allProducts = [];
  List<CategoryModel> _categories = [];
  List<dynamic> _banners = [];
  bool _isLoading = true;

  final PageController _pageController = PageController();
  Timer? _sliderTimer;
  int _currentBannerPage = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        ProductController.getAllProducts(),
        CategoryController.getAllCategories(),
        ApiConstants.get("${ApiConstants.baseUrl}/banners"),
      ]);

      setState(() {
        _allProducts = results[0] as List<ProductModel>;
        _categories = results[1] as List<CategoryModel>;
        final bannerResponse = results[2] as dynamic;
        if (bannerResponse.statusCode == 200) {
          _banners = jsonDecode(bannerResponse.body);
          _startAutoSlider();
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Error loading home data: $e");
    }
  }

  void _startAutoSlider() {
    if (_banners.isEmpty) return;
    _sliderTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentBannerPage < _banners.length - 1) {
        _currentBannerPage++;
      } else {
        _currentBannerPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentBannerPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    if (index == 1) Navigator.pushNamed(context, AppRoutes.cart);
    if (index == 2) Navigator.pushNamed(context, AppRoutes.profileInfo);
  }

  @override
  Widget build(BuildContext context) {
    final luxuryGold = Theme.of(context).primaryColor;

    final filteredProducts = _selectedCategoryId == "All"
        ? _allProducts
        : _allProducts.where((p) {
            final pCatId = (p.category is Map)
                ? p.category['_id']
                : p.category.toString();
            return pCatId == _selectedCategoryId;
          }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "CAMSTYLE",
          style: TextStyle(
            color: luxuryGold,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
            fontSize: 18,
          ),
        ),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: AppTheme.themeNotifier,
            builder: (context, mode, child) {
              return IconButton(
                icon: Icon(
                  mode == ThemeMode.light
                      ? Icons.nightlight_round
                      : Icons.wb_sunny_rounded,
                ),
                onPressed: () => AppTheme.toggleTheme(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // --- CATEGORIES SECTION ---
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Text(
                      "CATEGORIES",
                      style: TextStyle(
                        letterSpacing: 2,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: luxuryGold,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: _buildCategoryBar()),

                // --- BANNER SECTION ---
                if (_banners.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text(
                        "FLASH SALE",
                        style: TextStyle(
                          letterSpacing: 2,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: luxuryGold,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 180,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _banners.length,
                        onPageChanged: (index) => _currentBannerPage = index,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                _banners[index]['imageUrl'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 50),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],

                // --- PRODUCTS SECTION ---
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                    child: Text(
                      "OUR COLLECTION",
                      style: TextStyle(
                        letterSpacing: 2,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: luxuryGold,
                      ),
                    ),
                  ),
                ),
                filteredProducts.isEmpty
                    ? const SliverFillRemaining(
                        child: Center(child: Text("No products found.")),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio:
                                    0.65, // Taller cards for luxury feel
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                _buildProductCard(filteredProducts[index]),
                            childCount: filteredProducts.length,
                          ),
                        ),
                      ),
                const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: luxuryGold,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    final luxuryGold = Theme.of(context).primaryColor;
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length + 1,
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final id = isAll ? "All" : _categories[index - 1].id;
          final name = isAll
              ? "ALL"
              : _categories[index - 1].name.toUpperCase();
          final isSelected = _selectedCategoryId == id;

          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryId = id),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? luxuryGold : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? luxuryGold : Colors.grey.withOpacity(0.3),
                ),
              ),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? (Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white)
                      : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    final luxuryGold = Theme.of(context).primaryColor;
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.productDetail,
        arguments: product,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(
                        product.images.isNotEmpty ? product.images[0] : '',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () async {
                      bool success = await WishlistController.toggleWishlist(
                        product.id,
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? "Added to Wishlist"
                                  : "Removed from Wishlist",
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.name.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            "\$${product.price}",
            style: TextStyle(
              color: luxuryGold,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                FutureBuilder<UserModel?>(
                  future: UserController.getProfile(),
                  builder: (context, snapshot) {
                    final user = snapshot.data;
                    return UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage:
                            (user?.avatar != null && user!.avatar!.isNotEmpty)
                            ? NetworkImage(user.avatar!)
                            : null,
                        child: (user?.avatar == null || user!.avatar!.isEmpty)
                            ? const Icon(Icons.person, size: 40)
                            : null,
                      ),
                      accountName: Text(
                        user?.name ?? "User",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      accountEmail: Text(
                        user?.email ?? "",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  },
                ),
                _drawerItem(
                  Icons.home_outlined,
                  "HOME",
                  () => Navigator.pop(context),
                ),
                _drawerItem(Icons.person_outline, "EDIT PROFILE", () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                }),
                _drawerItem(Icons.favorite_outline, "WISHLIST", () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/wishlist');
                }),
                _drawerItem(Icons.help_outline, "HELP", () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/help');
                }),
                _drawerItem(Icons.history, "LOGIN LOGS", () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/login-logs');
                }),
              ],
            ),
          ),
          const Divider(),
          _drawerItem(Icons.logout, "LOGOUT", () async {
            await StorageHelper.logout();
            if (mounted)
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
          }, isError: true),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _drawerItem(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isError = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isError ? Colors.red : null),
      title: Text(
        label,
        style: TextStyle(
          letterSpacing: 2,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isError ? Colors.red : null,
        ),
      ),
      onTap: onTap,
    );
  }
}
