import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb; // Needed for Web check
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/user_controller.dart';
import '../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  UserModel? _user;
  XFile? _pickedImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final user = await UserController.getProfile();
    if (user != null) {
      setState(() {
        _user = user;
        _nameController.text = user.name;
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _pickedImage = image);
  }

  void _handleUpdate() async {
    setState(() => _isLoading = true);
    // Only send name and image here. Passwords are null.
    bool success = await UserController.updateProfile(
      context: context,
      name: _nameController.text.trim(),
      imageFile: _pickedImage,
    );
    setState(() => _isLoading = false);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Updated!")));
      _pickedImage = null;
      _fetchProfile();
    }
  }

  ImageProvider? _getAvatar() {
    if (_pickedImage != null) {
      return kIsWeb ? NetworkImage(_pickedImage!.path) : FileImage(File(_pickedImage!.path)) as ImageProvider;
    }
    if (_user?.avatar != null && _user!.avatar!.isNotEmpty) return NetworkImage(_user!.avatar!);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _getAvatar(),
                child: _getAvatar() == null ? const Icon(Icons.person, size: 60) : null,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ListTile(
              onTap: () => Navigator.pushNamed(context, '/change-password'),
              leading: const Icon(Icons.security),
              title: const Text("Security Settings"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              tileColor: Colors.grey[100],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleUpdate,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                child: const Text("SAVE CHANGES", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}