//import 'dart:typed_data'; // Needed for bytes
//import 'package:flutter/foundation.dart'; // To check if kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/admin_controller.dart';
import '../../controllers/category_controller.dart';
import '../../models/category_model.dart';

class NewProductScreen extends StatefulWidget {
  const NewProductScreen({super.key});

  @override
  State<NewProductScreen> createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _qty = TextEditingController();
  final _desc = TextEditingController();
  String? _selectedCategoryId;

  // Change: Store XFile instead of File to remain Web-compatible
  List<XFile> _selectedXFiles = [];
  bool _isLoading = false;

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);

    if (images.isNotEmpty) {
      setState(() {
        _selectedXFiles = images;
      });
    }
  }

  void _submit() async {
    if (_name.text.isEmpty || _selectedCategoryId == null || _selectedXFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and pick at least one image")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final Map<String, String> productData = {
      'name': _name.text,
      'price': _price.text,
      'quantity': _qty.text,
      'description': _desc.text,
      'category': _selectedCategoryId!,
    };

    // Pass the XFiles directly to the controller
    bool success = await AdminController.createProduct(
      context: context,
      fields: productData,
      imageFiles: _selectedXFiles, // We changed this from imagePaths
    );

    if (mounted) setState(() => _isLoading = false);
    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Product")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<CategoryModel>>(
              future: CategoryController.getAllCategories(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text("Product Images (Max 5)", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: _selectedXFiles.isEmpty
                          ? Center(
                              child: IconButton(
                                icon: const Icon(Icons.add_a_photo, size: 40),
                                onPressed: _pickImages,
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _selectedXFiles.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        // Use Image.network for Web preview (blob URL)
                                        child: Image.network(
                                          _selectedXFiles[index].path,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.cancel, color: Colors.red),
                                        onPressed: () => setState(() => _selectedXFiles.removeAt(index)),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                    ),
                    TextButton.icon(onPressed: _pickImages, icon: const Icon(Icons.image), label: const Text("Change/Add Images")),
                    const Divider(height: 30),
                    TextField(controller: _name, decoration: const InputDecoration(labelText: "Product Name")),
                    TextField(controller: _price, decoration: const InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
                    TextField(controller: _qty, decoration: const InputDecoration(labelText: "Quantity"), keyboardType: TextInputType.number),
                    TextField(controller: _desc, decoration: const InputDecoration(labelText: "Description"), maxLines: 3),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: _selectedCategoryId,
                      hint: const Text("Select Category"),
                      isExpanded: true,
                      items: snapshot.data!.map((cat) => DropdownMenuItem(value: cat.id, child: Text(cat.name))).toList(),
                      onChanged: (val) => setState(() => _selectedCategoryId = val),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                      child: const Text("CREATE PRODUCT"),
                    ),
                  ],
                );
              },
            ),
    );
  }
}