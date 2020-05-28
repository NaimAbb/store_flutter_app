import 'package:flutter/material.dart';
import 'package:store_flutter_app/db/db_helper.dart';
import 'package:store_flutter_app/models/address.dart';
import 'package:store_flutter_app/models/cart_item.dart';
import 'package:store_flutter_app/models/category.dart';
import 'package:store_flutter_app/models/product.dart';

class Client extends ChangeNotifier {
  DBHelper _db = new DBHelper();
  List<Category> _categories = [];
  List<Product> _productFeatured = [];
  List<Product> _productByCategory = [];
  List<Address> _allAddress = [];
  List<CartItem> _carts = [];

  int _totalItemInCart = 0;

  int get totalItemInCart => _totalItemInCart;

  List<Product> get getFeatured => [..._productFeatured];

  List<Product> get productCategory => [..._productByCategory];

  List<Address> get getAllAddress => [..._allAddress];

  List<Category> get categories => [..._categories];

  List<CartItem> get carts => [..._carts];

  Future<void> getCategories() async {
    try {
      final allCategories = await _db.getCategories();
      _categories = allCategories;
      // notifyListeners();
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

  Future<void> addToCart(CartItem cartItem) async {
    try {
      _db.addToCard(cartItem);
    } catch (error) {
      throw error;
    }
  }

  Future<void> reducingTheQuantity(int idProduct) async {
    try {
      await _db.reducingTheQuantity(idProduct);
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteItemFromCart(int idProduct) async {
    try {
      await _db.deleteItemFromCart(idProduct);
      await getAllItemsFromCart();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getAllItemsFromCart() async {
    try {
      final carts = await _db.getCarts();
      _carts = carts;
      notifyListeners();
    } catch (error) {}
  }

  Future<void> getCount() async {
    int total = 0;
    final carts = await _db.getCarts();
    for (var item in carts) {
      total += item.quantity;
    }
    _totalItemInCart = total;
    notifyListeners();
  }

  Future<void> addAddress(Address address)async{
    try{

     await _db.addAddress(address);
     _allAddress.add(address);
     notifyListeners();
    }catch(error){
      throw error;
    }
  }

  Future<void> getAllAddressForUser(int idUser) async {
    try {
      final address = await _db.getAddressForUser(idUser);
      _allAddress = address;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
