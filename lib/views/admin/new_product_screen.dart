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
  // --- LOGIC PRESERVED ---
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _qty = TextEditingController();
  final _desc = TextEditingController();
  String? _selectedCategoryId;

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

    bool success = await AdminController.createProduct(
      context: context,
      fields: productData,
      imageFiles: _selectedXFiles,
    );

    if (mounted) setState(() => _isLoading = false);
    if (success && mounted) Navigator.pop(context);
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
          "ADD PRODUCT",
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
          child: _isLoading
              ? Center(child: CircularProgressIndicator(color: primaryColor))
              : FutureBuilder<List<CategoryModel>>(
                  future: CategoryController.getAllCategories(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator(color: primaryColor));
                    }

                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      children: [
                        // 1. IMAGE CAROUSEL SECTION
                        Text(
                          "PRODUCT IMAGES (MAX 5)",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: theme.cardColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                          ),
                          child: _selectedXFiles.isEmpty
                              ? Center(
                                  child: TextButton.icon(
                                    onPressed: _pickImages,
                                    icon: Icon(Icons.add_a_photo_outlined, color: primaryColor),
                                    label: Text("ADD IMAGES", style: TextStyle(color: theme.hintColor)),
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.all(10),
                                  itemCount: _selectedXFiles.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: Image.network(
                                              _selectedXFiles[index].path,
                                              width: 130,
                                              height: 130,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 5,
                                            right: 5,
                                            child: GestureDetector(
                                              onTap: () => setState(() => _selectedXFiles.removeAt(index)),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: Colors.black54,
                                                  shape: BoxShape.circle,
                                                ),
                                                padding: const EdgeInsets.all(4),
                                                child: const Icon(Icons.close, color: Colors.white, size: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                        if (_selectedXFiles.isNotEmpty)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _pickImages,
                              child: Text("Change Images", style: TextStyle(color: primaryColor, fontSize: 12)),
                            ),
                          ),
                        
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(thickness: 0.5),
                        ),

                        // 2. INPUT FIELDS
                        _buildThemedField(controller: _name, label: "PRODUCT NAME", icon: Icons.shopping_bag_outlined, theme: theme),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: _buildThemedField(controller: _price, label: "PRICE (\$)", icon: Icons.attach_money, theme: theme, keyboardType: TextInputType.number)),
                            const SizedBox(width: 15),
                            Expanded(child: _buildThemedField(controller: _qty, label: "QTY", icon: Icons.inventory_2_outlined, theme: theme, keyboardType: TextInputType.number)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildThemedField(controller: _desc, label: "DESCRIPTION", icon: Icons.description_outlined, theme: theme, maxLines: 3),
                        
                        const SizedBox(height: 20),

                        // 3. CATEGORY DROPDOWN
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: theme.cardColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCategoryId,
                              hint: Text("SELECT CATEGORY", style: TextStyle(color: theme.hintColor, fontSize: 12, letterSpacing: 1)),
                              isExpanded: true,
                              dropdownColor: scaffoldBg,
                              icon: Icon(Icons.keyboard_arrow_down, color: primaryColor),
                              items: snapshot.data!.map((cat) => DropdownMenuItem(
                                value: cat.id, 
                                child: Text(cat.name, style: const TextStyle(fontSize: 14)),
                              )).toList(),
                              onChanged: (val) => setState(() => _selectedCategoryId = val),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // 4. SUBMIT BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: scaffoldBg,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              elevation: 0,
                            ),
                            child: const Text("CREATE PRODUCT", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
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
        contentPadding: const EdgeInsets.all(18),
      ),
    );
  }
}