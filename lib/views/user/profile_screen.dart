import 'package:flutter/material.dart';
import '../../controllers/user_controller.dart';
 // To handle Logout

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // In a real app, you would load the current user's name from local storage or a Provider
    _nameController.text = "Current User"; 
  }

  void _handleUpdate() async {
    setState(() => _isLoading = true);
    bool success = await UserController.updateProfile(
      context: context,
      name: _nameController.text,
      password: _passwordController.text,
    );
    setState(() => _isLoading = false);
    if (success) _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            // 1. CIRCLE AVATAR
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),

            // 2. NAME FIELD
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.badge),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // 3. PASSWORD FIELD
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "New Password (Leave blank to keep current)",
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // 4. UPDATE BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleUpdate,
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("UPDATE PROFILE"),
              ),
            ),
            
            const Divider(height: 60),

            // 5. LOGOUT OPTION
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () {
                // Add your logout logic here
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}