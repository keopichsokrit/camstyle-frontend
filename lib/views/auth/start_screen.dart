import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

class StartUpScreen extends StatelessWidget {
  const StartUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The overall page background color, defined in your app_theme.dart
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // CrossAxisAlign stretches the column horizontally, allowing 
            // the buttons at the bottom to fill the width.
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              // --- TOP SECTION (Welcome/App Info) ---
              // Using Expanded here ensures this section pushes the bottom section 
              // all the way down, leaving nice clean spacing.
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Placeholder for your app logo/icon
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        IconData(0xe21d, fontFamily: 'MaterialIcons'), // An app icon placeholder
                        size: 60,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    const Text(
                      "CamStyle",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    const Text(
                      "Discover your perfect style, right at your fingertips. Discover the latest trends with CamStyle.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey, // Simple and clean
                        height: 1.5, // Better readability
                      ),
                    ),
                  ],
                ),
              ),
              
              // --- BOTTOM SECTION (Login/Register Buttons) ---
              // This section will sit snugly at the bottom of the screen.
              Column(
                // Stretch to fill the width
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // LOGIN BUTTON (Primary Action)
                  // Requirement #4: Uses named route AppRoutes.login
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    child: const Text("Sign In to Continue"),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // REGISTER BUTTON (Secondary Action)
                  // Requirement #4: Uses named route AppRoutes.register
                  // OutlinedButton offers a clean, visual separation from the main button.
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                    child: const Text("Create a New Account"),
                  ),
                  
                  // Simple aesthetic spacing at the very bottom
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}