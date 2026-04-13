import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/storage_helper.dart';

class StartUpScreen extends StatefulWidget {
  const StartUpScreen({super.key});

  @override
  State<StartUpScreen> createState() => _StartUpScreenState();
}

class _StartUpScreenState extends State<StartUpScreen> {
  
  @override
  void initState() {
    super.initState();
    _checkSession(); 
  }

  Future<void> _checkSession() async {
    final token = await StorageHelper.getToken();
    final role = await StorageHelper.getRole();

    if (token != null && token.isNotEmpty) {
      if (!mounted) return;
      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, AppRoutes.adminHome);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.userHome);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Defining the palette based on the logo
    const Color luxuryGold = Color(0xFFC5A358); // Gold color from logo
    const Color midnightBlack = Color(0xFF0A0A0A); // Deep textured black

    return Scaffold(
      // Dark background to make the logo and gold accents pop
      backgroundColor: midnightBlack, 
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          // Subtle radial gradient to simulate the lighting in your logo image
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Colors.white.withOpacity(0.05),
              midnightBlack,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 1. LOGO SECTION - Using your actual logo asset
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('lib/assets/images/shoplogo.png'), // Ensure this path matches your logo
                      radius: 60,
                    ),
                  ),
                  
                  const SizedBox(height: 10),

                  // 2. TAGLINE - Using elegant spacing
                  Text(
                    "FASHION • STYLE • YOU",
                    style: TextStyle(
                      color: luxuryGold.withOpacity(0.8),
                      fontSize: 12,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  
                  const SizedBox(height: 60),

                  // 3. PRIMARY ACTION BUTTON (Luxury Gold Style)
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: luxuryGold,
                        foregroundColor: midnightBlack,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // More elegant rounded shape
                        ),
                      ),
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                      child: const Text(
                        "SIGN IN",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 4. SECONDARY ACTION BUTTON (Minimalist Outline)
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: luxuryGold.withOpacity(0.5), width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
                      child: const Text(
                        "CREATE ACCOUNT",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // 5. FOOTER
                  Text(
                    "Discover the luxury of style.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}