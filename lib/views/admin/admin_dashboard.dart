// import 'package:flutter/material.dart';
// import '../../core/routes/app_routes.dart';

// class AdminDashboard extends StatelessWidget {
//   const AdminDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Admin Panel"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSectionHeader("Product Management"),
//             const SizedBox(height: 10),
//             GridView.count(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisCount: 2,
//               crossAxisSpacing: 15,
//               mainAxisSpacing: 15,
//               children: [
//                 _adminCard(context, "Add Product", Icons.add_to_photos, Colors.blue, () {
//                   // Navigate to Add Product Form
//                 }),
//                 _adminCard(context, "Edit Details", Icons.edit_calendar, Colors.green, () {
//                   // Navigate to Product List to update Price/Name/Qty
//                 }),
//                 _adminCard(context, "Update Images", Icons.image_search, Colors.purple, () {
//                   // Calls your updateProductImages route
//                 }),
//                 _adminCard(context, "Inventory", Icons.inventory_2, Colors.red, () {
//                   // Quick stock updates
//                 }),
//               ],
//             ),
            
//             const SizedBox(height: 30),
            
//             _buildSectionHeader("Category Management"),
//             const SizedBox(height: 10),
//             GridView.count(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisCount: 2,
//               crossAxisSpacing: 15,
//               mainAxisSpacing: 15,
//               children: [
//                 _adminCard(context, "New Category", Icons.category, Colors.orange, () {
//                    // Navigate to Category Creation
//                 }),
//                 _adminCard(context, "Manage List", Icons.format_list_bulleted, Colors.teal, () {
//                    // Navigate to Category List
//                 }),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Text(
//       title,
//       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.1),
//     );
//   }

//   Widget _adminCard(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(color: color.withOpacity(0.3)),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 40, color: color),
//             const SizedBox(height: 10),
//             Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
                  _adminTile(context, "Add Product", Icons.add_box, Colors.blue, () {
                    // Navigate to Add Product Form
                  }),
                  _adminTile(context, "New Category", Icons.category, Colors.orange, () {
                    // Navigate to Category Form
                  }),
                  _adminTile(context, "Update Prices", Icons.monetization_on, Colors.green, () {
                    // Logic to edit product prices
                  }),
                  _adminTile(context, "Stock Levels", Icons.inventory, Colors.red, () {
                    // Logic to update quantity
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