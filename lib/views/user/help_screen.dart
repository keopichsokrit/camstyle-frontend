import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor; // Luxury Gold
    final scaffoldBg = theme.scaffoldBackgroundColor; // Midnight Black

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "DOCUMENTATION",
          style: TextStyle(
            color: primaryColor,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. PROJECT OVERVIEW SECTION
                _buildSectionHeader("PROJECT OVERVIEW", primaryColor),
                const SizedBox(height: 15),
                _buildGlassContainer(
                  theme,
                  const Text(
                    "The CamStyle Flutter application is a sophisticated, full-stack retail management ecosystem engineered with a focus on high-performance scalability, strict architectural integrity, and seamless cross-platform compatibility across Android, iOS, and Web environments. At its technical core, the project is built upon a rigorously decoupled Model-View-Controller (MVC) design pattern, which ensures a clean separation of concerns between the Node.js and Express-powered backend, the MongoDB Atlas database layer, and the highly responsive Flutter frontend. A defining characteristic of the CamStyle development process is its reliance on professional software engineering principles to handle the complex logic required for a modern retail system, allowing for a flexible structural efficiency that can grow alongside the business requirements. One of the most critical technical milestones achieved in this project was the resolution of the 'Multipart file only support where dart:io is available' error, which typically plagues Flutter Web applications; this was solved by re-engineering the engine to utilize byte-stream processing. By treating image data as raw byte streams, the application successfully bypasses the security-driven file system limitations of modern web browsers, enabling users to update their profile information and upload high-resolution avatars to Cloudinary regardless of whether they are using a mobile device or a desktop browser.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 13, height: 1.6,),
                  ),
                ),
                const SizedBox(height: 35),

                // 2. FRONTEND ARCHITECTURE SECTION
                _buildSectionHeader("FRONTEND ARCHITECTURE (FLUTTER)", primaryColor),
                const SizedBox(height: 15),
                _buildGlassContainer(
                  theme,
                  Column(
                    children: [
                      _buildFolderItem(theme, "core/", "The Engine: URLs, HTTP logic, and Global Theme."),
                      _buildFolderItem(theme, "models/", "Plain Data Objects and JSON serialization."),
                      _buildFolderItem(theme, "controllers/", "The Brain: Handles logic and API services."),
                      _buildFolderItem(theme, "views/", "The Design: UI Screens (Auth, Admin, User, Cart)."),
                      _buildFolderItem(theme, "widgets/", "Reusable UI components like buttons and inputs."),
                    ],
                  ),
                ),
                const SizedBox(height: 35),

                // 3. BACKEND ARCHITECTURE SECTION
                _buildSectionHeader("BACKEND ARCHITECTURE (NODE.JS)", primaryColor),
                const SizedBox(height: 15),
                _buildGlassContainer(
                  theme,
                  Column(
                    children: [
                      _buildFolderItem(theme, "config/", "Database (MongoDB) and Cloudinary setup."),
                      _buildFolderItem(theme, "controllers/", "Logic for CRUD, Auth, and Payments."),
                      _buildFolderItem(theme, "middleware/", "JWT Security and Role-Based Access rules."),
                      _buildFolderItem(theme, "models/", "Database Schemas (User, Product, Category)."),
                      _buildFolderItem(theme, "routes/", "API Endpoint definitions."),
                    ],
                  ),
                ),
                const SizedBox(height: 35),

                // 4. SECURITY & ROLES SECTION
                _buildSectionHeader("SECURITY & ACCESS CONTROL", primaryColor),
                const SizedBox(height: 15),
                _buildGlassContainer(
                  theme,
                  const Text(
                    "The application’s security architecture is robust, utilizing Role-Based Access Control (RBAC) to provide tailored user experiences for 'Admin' and 'User' roles, supported by a centralized JWT-based authentication system that manages session persistence. The UI/UX is governed by a centralized design system, ensuring that every screen—from the dynamic product category browser to the integrated shopping cart and the secure QR code payment generation system—remains visually consistent and easy to navigate.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 13, height: 1.6),
                  ),
                ),
                
                const SizedBox(height: 50),
                
                // FOOTER
                Center(
                  child: Text(
                    "CAMSTYLE v1.0.0 • 2026",
                    style: TextStyle(
                      color: theme.hintColor.withOpacity(0.3),
                      fontSize: 10,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 40,
          height: 2,
          color: color,
        ),
      ],
    );
  }

  Widget _buildGlassContainer(ThemeData theme, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: child,
    );
  }

  Widget _buildFolderItem(ThemeData theme, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.folder_rounded, size: 18, color: theme.primaryColor.withOpacity(0.7)),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 13, height: 1.4),
                children: [
                  TextSpan(
                    text: title,
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  TextSpan(
                    text: " - $description",
                    style: TextStyle(color: theme.hintColor.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}