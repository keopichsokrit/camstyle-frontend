import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
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
  // --- LOGIC PRESERVED ---
  final _nameController = TextEditingController();
  final _homeController = TextEditingController();
  final _cityController = TextEditingController();
  final _homeTownController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _selectedDate;
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
        _homeController.text = user.home;
        _cityController.text = user.city;
        _homeTownController.text = user.homeTown;
        _phoneController.text = user.phoneNumber;
        _selectedDate = user.birthdate;
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
    bool success = await UserController.updateProfile(
      context: context,
      name: _nameController.text.trim(),
      imageFile: _pickedImage,
      phoneNumber: _phoneController.text.trim(),
      home: _homeController.text.trim(),
      city: _cityController.text.trim(),
      homeTown: _homeTownController.text.trim(),
      birthdate: _selectedDate?.toIso8601String(),
    );
    setState(() => _isLoading = false);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated!")),
      );
      _pickedImage = null;
      _fetchProfile();
    }
  }

  ImageProvider? _getAvatar() {
    if (_pickedImage != null) {
      return kIsWeb
          ? NetworkImage(_pickedImage!.path)
          : FileImage(File(_pickedImage!.path)) as ImageProvider;
    }
    if (_user?.avatar != null && _user!.avatar!.isNotEmpty) {
      return NetworkImage(_user!.avatar!);
    }
    return null;
  }
  // -----------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor; // Your Gold
    final scaffoldBg = theme.scaffoldBackgroundColor; // Your Black

    if (_isLoading) {
      return Scaffold(
        backgroundColor: scaffoldBg,
        body: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "EDIT PROFILE",
          style: TextStyle(
            color: primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [theme.colorScheme.surface.withOpacity(0.1), scaffoldBg],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              children: [
                // 1. AVATAR PICKER SECTION
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryColor, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: theme.dividerColor.withOpacity(0.1),
                          backgroundImage: _getAvatar(),
                          child: _getAvatar() == null
                              ? Icon(Icons.person, size: 60, color: primaryColor)
                              : null,
                        ),
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: primaryColor,
                        child: Icon(Icons.camera_alt, size: 18, color: scaffoldBg),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // 2. INPUT FIELDS
                _buildEditField(context, "Full Name", _nameController, Icons.person_outline),
                const SizedBox(height: 20),
                _buildEditField(context, "Phone Number", _phoneController, Icons.phone_android_outlined, isPhone: true),
                const SizedBox(height: 20),

                // 3. BIRTHDATE PICKER (Luxury ListTile Style)
                InkWell(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => _selectedDate = picked);
                  },
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    decoration: BoxDecoration(
                      color: theme.cardColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.cake_outlined, color: primaryColor, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          _selectedDate == null
                              ? "Select Birthdate"
                              : "Birthdate: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                          style: theme.textTheme.bodyLarge,
                        ),
                        const Spacer(),
                        Icon(Icons.calendar_today, color: primaryColor, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 4. ADDRESS FIELDS
                _buildEditField(context, "Home Address", _homeController, Icons.home_outlined),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _buildEditField(context, "City", _cityController, Icons.location_city)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildEditField(context, "Home Town", _homeTownController, Icons.map_outlined)),
                  ],
                ),
                const SizedBox(height: 30),

                // 5. SECURITY BUTTON
                TextButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/change-password'),
                  icon: Icon(Icons.security, color: primaryColor, size: 20),
                  label: Text(
                    "Change Security Settings",
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),

                // 6. SAVE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleUpdate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: scaffoldBg,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    child: const Text(
                      "SAVE CHANGES",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditField(BuildContext context, String label, TextEditingController controller, IconData icon, {bool isPhone = false}) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.hintColor),
        prefixIcon: Icon(icon, color: theme.primaryColor, size: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: theme.primaryColor),
        ),
        filled: true,
        fillColor: theme.cardColor.withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }
}