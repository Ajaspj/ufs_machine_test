import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufs_machine_test/controller/product_controller/product_controller.dart';
import 'package:ufs_machine_test/model/product_model/product_model.dart';

class AddProductDialog extends StatefulWidget {
  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final imageController = TextEditingController();
  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  void submitProduct(BuildContext context) {
    final title = titleController.text;
    final description = descriptionController.text;
    final price = double.tryParse(priceController.text) ?? 0;
    final category = categoryController.text;
    final imageUrl = imageController.text;

    if (title.isNotEmpty &&
        description.isNotEmpty &&
        price > 0 &&
        category.isNotEmpty) {
      final newProduct = Product(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        price: price,
        description: description,
        image: imageUrl,
        category: category,
      );

      Provider.of<ProductController>(context, listen: false)
          .createProduct(newProduct)
          .then((_) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: imageController,
              decoration: InputDecoration(labelText: 'ImageUrl'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text('Submit'),
          onPressed: () => submitProduct(context),
        ),
      ],
    );
  }
}
