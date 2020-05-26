import 'package:flutter/material.dart';
import 'package:store_flutter_app/db/db_helper.dart';
import 'package:store_flutter_app/models/category.dart';
import 'package:store_flutter_app/models/product.dart';

class Client extends ChangeNotifier {
  DBHelper _db = new DBHelper();
  List<Category> _categories = [];
  List<Product> _productFeatured = [];
  List<Product> _productByCategory = [];

  List<Product> get getFeatured => [..._productFeatured];

  List<Product> get productCategory => [... _productByCategory];

  List<Category> get categories => [..._categories];

  Future<void> getCategories() async {
    try {
      final allCategories = await _db.getCategories();
      _categories = allCategories;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> getProductFeatured() async {
    try {
      final productFeatured = await _db.getProductFeatured();
      _productFeatured = productFeatured;
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> productByCategory(int idCategory) async {
    try {
      notifyListeners();
      final products = await _db.productsByCategory(idCategory);
      _productByCategory = products;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
