import 'dart:io';
import 'package:flutter/foundation.dart';
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
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final scaffoldBg = theme.scaffoldBackgroundColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "UPDATE PRODUCT",
          style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
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
          child: FutureBuilder<List<ProductModel>>(
            key: _refreshKey,
            future: ProductController.getAllProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: primaryColor));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No products found.", style: TextStyle(color: Colors.white70)));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final product = snapshot.data![index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: theme.cardColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: product.images.isNotEmpty
                            ? Image.network(product.images[0], width: 50, height: 50, fit: BoxFit.cover)
                            : Container(
                                width: 50, height: 50, 
                                color: primaryColor.withOpacity(0.1),
                                child: Icon(Icons.inventory_2_outlined, color: primaryColor),
                              ),
                      ),
                      title: Text(
                        product.name.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1),
                      ),
                      subtitle: Text(
                        "\$${product.price}",
                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
                      ),
                      trailing: Icon(Icons.edit_note_outlined, color: primaryColor),
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditProductForm(product: product)),
                        );
                        if (updated == true) setState(() => _refreshKey = UniqueKey());
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
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
  // --- LOGIC PRESERVED ---
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
    if (_name.text.trim().isEmpty || _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name and Category are required")),
      );
      return;
    }

    setState(() => _isLoading = true);

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
  // -----------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final scaffoldBg = theme.scaffoldBackgroundColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("EDIT ${widget.product.name.toUpperCase()}",
            style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
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
          child: _isLoading
              ? Center(child: CircularProgressIndicator(color: primaryColor))
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  children: [
                    Text("REPLACE IMAGES",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor, letterSpacing: 1.5)),
                    Text("(Overwrites existing product gallery)",
                        style: TextStyle(fontSize: 10, color: theme.hintColor)),
                    const SizedBox(height: 15),
                    
                    // Glass-morphic Image Selection Area
                    Container(
                      height: 110,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.cardColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                      ),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ..._newImages.map((file) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: kIsWeb
                                      ? Image.network(file.path, width: 85, height: 85, fit: BoxFit.cover)
                                      : Image.file(File(file.path), width: 85, height: 85, fit: BoxFit.cover),
                                ),
                              )),
                          GestureDetector(
                            onTap: _pickNewImages,
                            child: Container(
                              width: 85,
                              height: 85,
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.05),
                                border: Border.all(color: primaryColor.withOpacity(0.3), style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.add_a_photo_outlined, color: primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(thickness: 0.5)),

                    _buildThemedField(controller: _name, label: "PRODUCT NAME", icon: Icons.title, theme: theme),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(child: _buildThemedField(controller: _price, label: "PRICE", icon: Icons.attach_money, theme: theme, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
                        const SizedBox(width: 15),
                        Expanded(child: _buildThemedField(controller: _qty, label: "STOCK", icon: Icons.inventory_2_outlined, theme: theme, keyboardType: TextInputType.number)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildThemedField(controller: _desc, label: "DESCRIPTION", icon: Icons.description_outlined, theme: theme, maxLines: 3),
                    const SizedBox(height: 20),

                    // Themed Dropdown for Category
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: theme.cardColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                      ),
                      child: FutureBuilder<List<CategoryModel>>(
                        future: CategoryController.getAllCategories(),
                        builder: (context, snapshot) {
                          return DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCategoryId,
                              isExpanded: true,
                              dropdownColor: scaffoldBg,
                              hint: Text("SELECT CATEGORY", style: TextStyle(color: theme.hintColor, fontSize: 11)),
                              icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                              items: snapshot.hasData 
                                  ? snapshot.data!.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name, style: const TextStyle(fontSize: 14)))).toList()
                                  : [],
                              onChanged: (val) => setState(() => _selectedCategoryId = val),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitUpdate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: scaffoldBg,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text("SAVE CHANGES", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                      ),
                    ),
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.hintColor, fontSize: 10, letterSpacing: 1),
        prefixIcon: Icon(icon, color: theme.primaryColor, size: 18),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.1))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: theme.primaryColor)),
        filled: true,
        fillColor: theme.cardColor.withOpacity(0.05),
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.all(18),
      ),
    );
  }
}