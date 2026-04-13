import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import '../../controllers/admin_controller.dart';

class NewCategoryScreen extends StatefulWidget {
  const NewCategoryScreen({super.key});

  @override
  State<NewCategoryScreen> createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  // --- LOGIC PRESERVED ---
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  XFile? _selectedXFile; 
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, 
    );
    
    if (pickedFile != null) {
      setState(() {
        _selectedXFile = pickedFile;
      });
    }
  }

  void _submit() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Category name is required")),
      );
      return;
    }

    setState(() => _isLoading = true);

    bool success = await AdminController.createCategory(
      context: context,
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      imageFile: _selectedXFile, 
    );

    if (mounted) setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
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
          "NEW CATEGORY",
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
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. IMAGE PREVIEW (Themed)
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.cardColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                        ),
                        child: _selectedXFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.network(_selectedXFile!.path, fit: BoxFit.cover),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate_outlined, size: 50, color: primaryColor),
                                  const SizedBox(height: 12),
                                  Text(
                                    "UPLOAD CATEGORY IMAGE",
                                    style: TextStyle(
                                      color: theme.hintColor.withOpacity(0.6),
                                      fontSize: 12,
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 2. NAME FIELD
                    _buildThemedField(
                      controller: _nameController,
                      label: "CATEGORY NAME",
                      icon: Icons.label_important_outline,
                      theme: theme,
                    ),
                    const SizedBox(height: 20),

                    // 3. DESCRIPTION FIELD
                    _buildThemedField(
                      controller: _descController,
                      label: "DESCRIPTION",
                      icon: Icons.description_outlined,
                      maxLines: 4,
                      theme: theme,
                    ),
                    const SizedBox(height: 40),

                    // 4. SAVE BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
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
                                "SAVE CATEGORY",
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
              if (_isLoading)
                const ModalBarrier(dismissible: false, color: Colors.black26),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemedField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    required ThemeData theme,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.hintColor, fontSize: 12, letterSpacing: 1),
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
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}