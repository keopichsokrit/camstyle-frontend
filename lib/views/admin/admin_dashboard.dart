import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_theme.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

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
        
        title: Text(
          "ADMIN PANEL",
          style: TextStyle(
            color: primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
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
        ],
      ),
      // --- PREMIUM DRAWER ADDED ---
      drawer: Drawer(
        backgroundColor: scaffoldBg,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: theme.cardColor.withOpacity(0.05),
                border: Border(bottom: BorderSide(color: theme.dividerColor.withOpacity(0.1))),
              ),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor, width: 2),
                ),
                child: const CircleAvatar(
                  
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.person_outline, color: Color.fromARGB(255, 157, 141, 1), size: 40),
                ),
              ),
              accountName: const Text("ADMINISTRATOR", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
              accountEmail: Text("", style: TextStyle(color: theme.hintColor)),
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text("LOGOUT", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
            ),
            const SizedBox(height: 20),
          ],
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "INVENTORY MANAGEMENT",
                  style: TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.bold, 
                    color: primaryColor,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Container(width: 40, height: 2, color: primaryColor),
                const SizedBox(height: 30),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _adminTile(context, "NEW PRODUCT", Icons.add_business_outlined, () {
                        Navigator.pushNamed(context, '/new-product');
                      }),
                      _adminTile(context, "NEW CATEGORY", Icons.category_outlined, () {
                        Navigator.pushNamed(context, '/new-category');
                      }),
                      _adminTile(context, "UPDATE PRODUCT", Icons.edit_note_outlined, () {
                        Navigator.pushNamed(context, '/update-product');
                      }),
                      _adminTile(context, "UPDATE CATEGORY", Icons.settings_suggest_outlined, () {
                        Navigator.pushNamed(context, '/update-category');
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _adminTile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: theme.primaryColor),
            ),
            const SizedBox(height: 15),
            Text(
              title, 
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold, 
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}