import 'package:flutter/material.dart';
import '../../controllers/user_controller.dart';
import '../../models/user_model.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _CloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      // Uses the default icon theme color from your AppBar theme
      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
      onPressed: () => Navigator.pop(context),
    );
  }
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  UserModel? _user;
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
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pulling colors directly from your Theme configuration
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor; // Your Luxury Gold
    final scaffoldBg = theme.scaffoldBackgroundColor; // Your Midnight Black

    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _CloseButton(),
        title: Text(
          "PROFILE DETAILS",
          style: TextStyle(
            color: primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: primaryColor),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
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
                // 1. AVATAR SECTION
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryColor, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: theme.dividerColor.withOpacity(0.1),
                    backgroundImage:
                        (_user?.avatar != null && _user!.avatar!.isNotEmpty)
                        ? NetworkImage(_user!.avatar!)
                        : null,
                    child: (_user?.avatar == null || _user!.avatar!.isEmpty)
                        ? Icon(Icons.person, size: 60, color: primaryColor)
                        : null,
                  ),
                ),
                const SizedBox(height: 40),

                // 2. DATA FIELDS
                _buildReadOnlyField(
                  context,
                  "Full Name",
                  _user?.name ?? "",
                  Icons.person_outline,
                ),
                const SizedBox(height: 20),
                _buildReadOnlyField(
                  context,
                  "Phone Number",
                  _user?.phoneNumber ?? "Not provided",
                  Icons.phone_android_outlined,
                ),
                const SizedBox(height: 20),
                _buildReadOnlyField(
                  context,
                  "Birthdate",
                  _user?.birthdate == null
                      ? "Not set"
                      : "${_user!.birthdate!.day}/${_user!.birthdate!.month}/${_user!.birthdate!.year}",
                  Icons.cake_outlined,
                ),
                const SizedBox(height: 20),
                _buildReadOnlyField(
                  context,
                  "Home Address",
                  _user?.home ?? "Not set",
                  Icons.home_outlined,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildReadOnlyField(
                        context,
                        "City",
                        _user?.city ?? "N/A",
                        Icons.location_city,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildReadOnlyField(
                        context,
                        "Home Town",
                        _user?.homeTown ?? "N/A",
                        Icons.map_outlined,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // 3. FOOTER NOTE
                Text(
                  "Click the pencil icon at the top to update your info.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: theme.hintColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return TextField(
      controller: TextEditingController(text: value),
      readOnly: true,
      enabled: false,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.hintColor),
        prefixIcon: Icon(icon, color: theme.primaryColor, size: 20),
        // Uses your global input decoration or falls back to theme colors
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
        ),
        filled: true,
        fillColor: theme.cardColor.withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }
}
