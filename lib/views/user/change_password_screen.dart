import 'package:flutter/material.dart';
import '../../controllers/user_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // --- LOGIC PRESERVED ---
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  bool _isLoading = false;

  void _handlePasswordChange() async {
    if (_oldPassController.text.isEmpty || _newPassController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill both fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    bool success = await UserController.updateProfile(
      context: context,
      oldPassword: _oldPassController.text,
      newPassword: _newPassController.text,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed!")),
      );
      Navigator.pop(context);
    }
  }
  // -----------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor; // Luxury Gold
    final scaffoldBg = theme.scaffoldBackgroundColor; // Midnight Black

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
          "SECURITY",
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
            colors: [
              theme.colorScheme.surface.withOpacity(0.1),
              scaffoldBg,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Icon(Icons.lock_reset_rounded, size: 80, color: primaryColor),
                const SizedBox(height: 20),
                Text(
                  "Update your security credentials",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 40),

                // 1. OLD PASSWORD FIELD
                _buildPasswordField(
                  context: context,
                  controller: _oldPassController,
                  label: "Current Password",
                  icon: Icons.lock_outline,
                ),
                const SizedBox(height: 20),

                // 2. NEW PASSWORD FIELD
                _buildPasswordField(
                  context: context,
                  controller: _newPassController,
                  label: "New Password",
                  icon: Icons.enhanced_encryption_outlined,
                ),
                const SizedBox(height: 40),

                // 3. SAVE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handlePasswordChange,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: scaffoldBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: scaffoldBg)
                        : const Text(
                            "SAVE PASSWORD",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
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

  Widget _buildPasswordField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      obscureText: true,
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