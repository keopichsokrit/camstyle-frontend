import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("System Documentation"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. PROJECT OVERVIEW SECTION
            const Text(
              "PROJECT OVERVIEW",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const Divider(),
            const Text(
              "The CamStyle Flutter application is a sophisticated, full-stack retail management ecosystem engineered with a focus on high-performance scalability, strict architectural integrity, and seamless cross-platform compatibility across Android, iOS, and Web environments. At its technical core, the project is built upon a rigorously decoupled Model-View-Controller (MVC) design pattern, which ensures a clean separation of concerns between the Node.js and Express-powered backend, the MongoDB Atlas database layer, and the highly responsive Flutter frontend. A defining characteristic of the CamStyle development process is its reliance on professional software engineering principles to handle the complex logic required for a modern retail system, allowing for a flexible structural efficiency that can grow alongside the business requirements. One of the most critical technical milestones achieved in this project was the resolution of the 'Multipart file only support where dart:io is available' error, which typically plagues Flutter Web applications; this was solved by re-engineering the engine to utilize byte-stream processing. By treating image data as raw byte streams, the application successfully bypasses the security-driven file system limitations of modern web browsers, enabling users to update their profile information and upload high-resolution avatars to Cloudinary regardless of whether they are using a mobile device or a desktop browser.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 30),

            // 2. FRONTEND ARCHITECTURE SECTION
            const Text(
              "FRONTEND ARCHITECTURE (FLUTTER)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const Divider(),
            _buildFolderItem("core/", "The Engine: URLs, HTTP logic, and Global Theme."),
            _buildFolderItem("models/", "Plain Data Objects and JSON serialization."),
            _buildFolderItem("controllers/", "The Brain: Handles logic and API services."),
            _buildFolderItem("views/", "The Design: UI Screens (Auth, Admin, User, Cart)."),
            _buildFolderItem("widgets/", "Reusable UI components like buttons and inputs."),
            const SizedBox(height: 30),

            // 3. BACKEND ARCHITECTURE SECTION
            const Text(
              "BACKEND ARCHITECTURE (NODE.JS)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const Divider(),
            _buildFolderItem("config/", "Database (MongoDB) and Cloudinary setup."),
            _buildFolderItem("controllers/", "Logic for CRUD, Auth, and Payments."),
            _buildFolderItem("middleware/", "JWT Security and Role-Based Access rules."),
            _buildFolderItem("models/", "Database Schemas (User, Product, Category)."),
            _buildFolderItem("routes/", "API Endpoint definitions."),
            const SizedBox(height: 30),

            // 4. SECURITY & ROLES SECTION
            const Text(
              "SECURITY & ACCESS CONTROL",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const Divider(),
            const Text(
              "The application’s security architecture is robust, utilizing Role-Based Access Control (RBAC) to provide tailored user experiences for 'Admin' and 'User' roles, supported by a centralized JWT-based authentication system that manages session persistence. The UI/UX is governed by a centralized design system, ensuring that every screen—from the dynamic product category browser to the integrated shopping cart and the secure QR code payment generation system—remains visually consistent and easy to navigate.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 40),
            
            // FOOTER
            const Center(
              child: Text(
                "CamStyle v1.0.0 - 2026",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper Widget to display folder structure items
  Widget _buildFolderItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.folder_open, size: 18, color: Colors.orangeAccent),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 14),
                children: [
                  TextSpan(text: "$title ", style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                  TextSpan(text: "- $description", style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}