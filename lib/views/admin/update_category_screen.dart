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
    return Scaffold(
      appBar: AppBar(title: const Text("Select Category to Edit")),
      body: FutureBuilder<List<CategoryModel>>(
        key: _refreshKey,
        future: CategoryController.getAllCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return const Center(child: Text("Error loading categories"));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No categories found"));

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final cat = snapshot.data![index];
              return ListTile(
                title: Text(cat.name),
                subtitle: Text(cat.description ?? "No description"),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final success = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditCategoryForm(category: cat)),
                  );
                  if (success == true) setState(() => _refreshKey = UniqueKey());
                },
              );
            },
          );
        },
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

    // Call update with only text fields
    bool success = await AdminController.updateCategory(
      context: context,
      id: widget.category.id,
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      imageFile: null, // Explicitly null as we aren't updating images
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Category Text")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController, 
              decoration: const InputDecoration(labelText: "Category Name", border: OutlineInputBorder())
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _descController, 
              maxLines: 3, 
              decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder())
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text("SAVE TEXT CHANGES"),
              ),
            )
          ],
        ),
      ),
    );
  }
}