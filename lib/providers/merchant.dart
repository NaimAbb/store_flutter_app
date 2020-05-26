import 'package:flutter/material.dart';
import 'package:store_flutter_app/db/db_helper.dart';
import 'package:store_flutter_app/models/category.dart';
import 'package:store_flutter_app/models/product.dart';
import 'package:store_flutter_app/utils/constants.dart';

class Merchant extends ChangeNotifier {
  DBHelper _db = new DBHelper();
  List<Category> _categories = [];
  bool _chooseImage = false;

  void changeValueChooseImage() {
    _chooseImage = true;
    notifyListeners();
  }

  List<Category> get categories {
    return [..._categories];
  }

  bool get valueChooseImage {
    return _chooseImage;
  }

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

  Future<void> addProduct(Product product) async {
    try {
      await _db.addProduct(
          product, int.parse(Constants.sharedPreferencesLocal.getUserId()));
    }catch(error){
      throw error;
    }
  }
}
