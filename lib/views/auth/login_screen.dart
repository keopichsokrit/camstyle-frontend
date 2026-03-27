import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../core/routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. CIRCLE AVATAR (Placeholder for your asset)
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 70, color: Colors.white),
                ),
                const SizedBox(height: 40),

                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Log in to your CamStyle account",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // 2. LOGIN BOX (Email)
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 3. LOGIN BOX (Password)
                TextField(
                  controller: _passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                // 4. FORGOT PASSWORD LINK
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton(
                //     onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                //     child: const Text(
                //       "Forgot Password?",
                //       style: TextStyle(color: Colors.blueAccent),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20),

                // 5. LOGIN BUTTON (Keeping your logic exactly the same)
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
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
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 6. REGISTER LINK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.register),
                      child: const Text(
                        "Register Now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
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
    );
  }
}
