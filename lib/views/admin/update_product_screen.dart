import 'dart:io'; // Needed for File(file.path)
import 'package:flutter/foundation.dart'; // Needed for kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/admin_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/category_controller.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({super.key});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  Key _refreshKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Product to Edit")),
      body: FutureBuilder<List<ProductModel>>(
        key: _refreshKey,
        future: ProductController.getAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No products found."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final product = snapshot.data![index];
              return ListTile(
                leading: product.images.isNotEmpty
                    ? Image.network(
                        product.images[0],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.inventory),
                title: Text(product.name),
                subtitle: Text("\$${product.price}"),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProductForm(product: product),
                    ),
                  );
                  if (updated == true)
                    setState(() => _refreshKey = UniqueKey());
                },
              );
            },
          );
        },
      ),
    );
  }
}

class EditProductForm extends StatefulWidget {
  final ProductModel product;
  const EditProductForm({super.key, required this.product});

  @override
  State<EditProductForm> createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  late TextEditingController _name, _price, _qty, _desc;
  String? _selectedCategoryId;
  List<XFile> _newImages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.product.name);
    _price = TextEditingController(text: widget.product.price.toString());
    _qty = TextEditingController(text: widget.product.quantity.toString());
    _desc = TextEditingController(text: widget.product.description);

    // Safety check for populated category objects from backend
    if (widget.product.category is Map) {
      _selectedCategoryId = widget.product.category['_id']?.toString();
    } else {
      _selectedCategoryId = widget.product.category?.toString();
    }
  }

  Future<void> _pickNewImages() async {
    final images = await ImagePicker().pickMultiImage(imageQuality: 70);
    if (images.isNotEmpty) {
      setState(() => _newImages = images);
    }
  }

  void _submitUpdate() async {
    // Basic validation
    if (_name.text.trim().isEmpty || _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name and Category are required")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Prepare the fields map
    // Note: We use .trim() to prevent accidental spaces causing backend casting errors
    final Map<String, dynamic> fields = {
      'name': _name.text.trim(),
      'price': double.parse(_price.text.trim()),
      'quantity': int.parse(_qty.text.trim()),
      'description': _desc.text.trim(),
      'category': _selectedCategoryId!,
    };

    bool success = await AdminController.updateProduct(
      context: context,
      id: widget.product.id,
      fields: fields,
      imageFiles: _newImages,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit ${widget.product.name}")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Replace Current Images",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  "(Selecting new images will override old ones)",
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // Show preview of newly selected images
                    ..._newImages.map(
                      (file) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: kIsWeb
                            ? Image.network(
                                file.path,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(file.path),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    // Add button
                    InkWell(
                      onTap: _pickNewImages,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 40),
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: "Product Name"),
                ),
                TextField(
                  controller: _price,
                  decoration: const InputDecoration(
                    labelText: "Price",
                    prefixText: "\$ ",
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                TextField(
                  controller: _qty,
                  decoration: const InputDecoration(
                    labelText: "Stock Quantity",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _desc,
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),

                const Text(
                  "Category",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                FutureBuilder<List<CategoryModel>>(
                  future: CategoryController.getAllCategories(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const LinearProgressIndicator();

                    return DropdownButton<String>(
                      value: _selectedCategoryId,
                      isExpanded: true,
                      hint: const Text("Select Category"),
                      items: snapshot.data!
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.id,
                              child: Text(c.name),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedCategoryId = val),
                    );
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _submitUpdate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("SAVE PRODUCT CHANGES"),
                ),
              ],
            ),
    );
  }
}
