import 'package:flutter/material.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/category_controller.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';
import '../../core/routes/app_routes.dart';
import '../../controllers/user_controller.dart';
import '../../models/user_model.dart';
import '../../core/utils/storage_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedCategoryId = "All";
  
  // Data lists
  List<ProductModel> _allProducts = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Fetch both products and categories once
  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        ProductController.getAllProducts(),
        CategoryController.getAllCategories(),
      ]);

      setState(() {
        _allProducts = results[0] as List<ProductModel>;
        _categories = results[1] as List<CategoryModel>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Error loading home data: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    if (index == 1) Navigator.pushNamed(context, AppRoutes.cart);
    if (index == 2) Navigator.pushNamed(context, AppRoutes.profile);
  }

  @override
  Widget build(BuildContext context) {
    // Filter logic: Check if category ID matches or show all
    final filteredProducts = _selectedCategoryId == "All"
        ? _allProducts
        : _allProducts.where((p) {
            final pCatId = (p.category is Map) ? p.category['_id'] : p.category.toString();
            return pCatId == _selectedCategoryId;
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("CamStyle Shop"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notification_add),
            onPressed: () {},
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildCategoryBar(),
                Expanded(
                  child: filteredProducts.isEmpty
                      ? const Center(child: Text("No products found in this category."))
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) => _buildProductCard(filteredProducts[index]),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat_bubble_outline),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        // Add 1 to length for the "All" chip
        itemCount: _categories.length + 1,
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final category = isAll ? null : _categories[index - 1];
          final id = isAll ? "All" : category!.id;
          final name = isAll ? "All" : category!.name;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(name),
              selected: _selectedCategoryId == id,
              selectedColor: const Color.fromARGB(255, 82, 193, 252),
              labelStyle: TextStyle(
                color: _selectedCategoryId == id ? Colors.white : Colors.black,
              ),
              onSelected: (selected) {
                setState(() => _selectedCategoryId = id);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<UserModel?>(
            future: UserController.getProfile(),
            builder: (context, snapshot) {
              final user = snapshot.data;
              return UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.blueAccent),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: (user?.avatar != null && user!.avatar!.isNotEmpty)
                      ? NetworkImage(user.avatar!)
                      : null,
                  child: (user?.avatar == null || user!.avatar!.isEmpty)
                      ? const Icon(Icons.person, size: 40, color: Colors.blueAccent)
                      : null,
                ),
                accountName: Text(user?.name ?? "Loading...", style: const TextStyle(fontWeight: FontWeight.bold)),
                accountEmail: Text(user?.email ?? ""),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text("My Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () async {
              await StorageHelper.logout();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.productDetail, arguments: product),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: product.images.isNotEmpty
                    ? Image.network(product.images[0], fit: BoxFit.cover, width: double.infinity)
                    : Container(color: Colors.grey[200], child: const Icon(Icons.image_not_supported)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text("\$${product.price}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}