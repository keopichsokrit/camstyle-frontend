// lib/views/auth/register_screen.dart
import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../core/routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false; // Added loading state

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    setState(() => _isLoading = true);
    
    await AuthController.register(
      context, 
      _nameController.text.trim(), 
      _emailController.text.trim(), 
      _passController.text.trim(),
    );

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: SingleChildScrollView( // Added scroll view to prevent keyboard overflow
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            TextField(
              controller: _nameController, 
              decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _emailController, 
              decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passController, 
              obscureText: true, 
              decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("Register"),
              ),
            ),
            
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
              child: const Text("Already have an account? Login"),
            )
          ],
        ),
      ),
    );
  }
}