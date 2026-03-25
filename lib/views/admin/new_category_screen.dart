import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Handles images cross-platform
import '../../controllers/admin_controller.dart';

class NewCategoryScreen extends StatefulWidget {
  const NewCategoryScreen({super.key});

  @override
  State<NewCategoryScreen> createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  
  // CHANGE: Use XFile instead of File for Web compatibility
  XFile? _selectedXFile; 
  bool _isLoading = false;

  // Function to pick image from gallery
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

  // Submit logic to bridge UI and Controller
  void _submit() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Category name is required")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Call the AdminController using the updated named parameter 'imageFile'
    bool success = await AdminController.createCategory(
      context: context,
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      imageFile: _selectedXFile, // Passing XFile here
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create New Category")),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Preview Area
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: _selectedXFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            // Image.network works for XFile.path on both Web and Mobile
                            child: Image.network(_selectedXFile!.path, fit: BoxFit.cover),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                              SizedBox(height: 10),
                              Text("Tap to select category image"),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Category Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.label),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading 
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                      )
                    : const Text("SAVE CATEGORY", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const ModalBarrier(dismissible: false, color: Colors.black12),
        ],
      ),
    );
  }
}