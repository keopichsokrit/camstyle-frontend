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
      appBar: AppBar(title: const Text("Welcome Back")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            const SizedBox(height: 15),
            TextField(controller: _passController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => AuthController.login(
                context, _emailController.text, _passController.text
              ),
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
              child: const Text("New here? Create Account"),
            )
          ],
        ),
      ),
    );
  }
}