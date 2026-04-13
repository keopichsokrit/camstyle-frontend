import 'package:flutter/material.dart';
import '../../controllers/admin_controller.dart';
import '../../controllers/category_controller.dart';
import '../../models/category_model.dart';

class UpdateCategoryScreen extends StatefulWidget {
  const UpdateCategoryScreen({super.key});

  @override
  State<UpdateCategoryScreen> createState() => _UpdateCategoryScreenState();
}

class _UpdateCategoryScreenState extends State<UpdateCategoryScreen> {
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
          "SELECT CATEGORY",
          style: TextStyle(
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
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
          child: FutureBuilder<List<CategoryModel>>(
            key: _refreshKey,
            future: CategoryController.getAllCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: primaryColor));
              }
              if (snapshot.hasError) {
                return const Center(child: Text("Error loading categories", style: TextStyle(color: Colors.white70)));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No categories found", style: TextStyle(color: Colors.white70)));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final cat = snapshot.data![index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: theme.cardColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      title: Text(
                        cat.name.toUpperCase(),
                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 14),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          cat.description ?? "No description provided.",
                          style: TextStyle(color: theme.hintColor, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      trailing: Icon(Icons.edit_outlined, color: primaryColor, size: 20),
                      onTap: () async {
                        final success = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditCategoryForm(category: cat)),
                        );
                        if (success == true) setState(() => _refreshKey = UniqueKey());
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

class EditCategoryForm extends StatefulWidget {
  final CategoryModel category;
  const EditCategoryForm({super.key, required this.category});

  @override
  State<EditCategoryForm> createState() => _EditCategoryFormState();
}

class _EditCategoryFormState extends State<EditCategoryForm> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _descController = TextEditingController(text: widget.category.description);
  }

  void _submit() async {
    if (_nameController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);

    bool success = await AdminController.updateCategory(
      context: context,
      id: widget.category.id,
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      imageFile: null,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) Navigator.pop(context, true);
    }
  }

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
          "EDIT DETAILS",
          style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildThemedField(
                  controller: _nameController,
                  label: "CATEGORY NAME",
                  icon: Icons.label_outline,
                  theme: theme,
                ),
                const SizedBox(height: 20),
                _buildThemedField(
                  controller: _descController,
                  label: "DESCRIPTION",
                  icon: Icons.description_outlined,
                  maxLines: 4,
                  theme: theme,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: scaffoldBg,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: scaffoldBg)
                        : const Text("SAVE CHANGES", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  ),
                )
              ],
            ),
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
      style: const TextStyle(fontSize: 14, color: Colors.white),
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