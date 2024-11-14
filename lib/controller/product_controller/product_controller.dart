import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ufs_machine_test/model/product_model/product_model.dart';

class ProductController with ChangeNotifier {
  List<Product> productlist = [];
  bool _isLoading = false;

  List<Product> get products => productlist;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));
      if (response.statusCode == 200) {
        final List<dynamic> productList = json.decode(response.body);
        productlist =
            productList.map((json) => Product.fromJson(json)).toList();
      }
    } catch (error) {
      print('Error fetching products: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await http.delete(Uri.parse('https://fakestoreapi.com/products/$id'));
      productlist.removeWhere((product) => product.id == id);
      notifyListeners();
    } catch (error) {
      print('Error deleting product: $error');
    }
  }

  Future<void> createProduct(Product product) async {
    final url = Uri.parse('https://fakestoreapi.com/products');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'image': product.image,
          'category': product.category,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);

        products.add(Product.fromJson(responseData));
        notifyListeners();
      } else {
        print('Failed to add product. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding product: $error');
    }
  }
}
