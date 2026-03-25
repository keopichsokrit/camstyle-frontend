
import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Inventory Management", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  // 1. Navigate to New Product Screen
                  _adminTile(context, "New Product", Icons.add_box, Colors.blue, () {
                    Navigator.pushNamed(context, '/new-product'); 
                  }),

                  // 2. Navigate to New Category Screen
                  _adminTile(context, "New Category", Icons.category, Colors.orange, () {
                    Navigator.pushNamed(context, '/new-category');
                  }),

                  // 3. Navigate to Update Product List
                  _adminTile(context, "Update Product", Icons.edit_note, Colors.green, () {
                    Navigator.pushNamed(context, '/update-product');
                  }),

                  // 4. Navigate to Update Category List
                  _adminTile(context, "Update Category", Icons.settings_suggest, Colors.red, () {
                    Navigator.pushNamed(context, '/update-category');
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _adminTile(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}