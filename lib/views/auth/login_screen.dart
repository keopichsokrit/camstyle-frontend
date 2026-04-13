import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../core/routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Matching the palette from your StartUp screen
    const Color luxuryGold = Color(0xFFC5A358);
    const Color midnightBlack = Color(0xFF0A0A0A);

    return Scaffold(
      backgroundColor: midnightBlack,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight, // Subtle glow from the corner
            radius: 1.5,
            colors: [Colors.white.withOpacity(0.05), midnightBlack],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 1. BACK BUTTON
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 2. LOGO / ICON SECTION
                        CircleAvatar(
                          backgroundImage: AssetImage(
                            'lib/assets/images/shoplogo.png',
                          ), // Using your logo asset
                          radius: 60,
                        ),
                        const SizedBox(height: 30),

                        Text(
                          "WELCOME BACK",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: luxuryGold,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Sign in to continue your style journey",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 50),

                        // 3. EMAIL FIELD
                        TextField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email Address",
                            labelStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                            ),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: luxuryGold,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: luxuryGold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 4. PASSWORD FIELD
                        TextField(
                          controller: _passController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: luxuryGold,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: luxuryGold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // 5. LOGIN BUTTON (Logic untouched)
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: luxuryGold,
                              foregroundColor: midnightBlack,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () => AuthController.login(
                              context,
                              _emailController.text.trim(),
                              _passController.text.trim(),
                            ),
                            child: const Text(
                              "LOGIN",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // 6. REGISTER LINK
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "New to CamStyle?",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                AppRoutes.register,
                              ),
                              child: const Text(
                                "Join Now",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: luxuryGold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
