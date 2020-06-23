import 'package:flutter/material.dart';
import 'package:store_flutter_app/db/db_helper.dart';

class CartItem extends ChangeNotifier {
  String _id;
  String _idProdcut;
  String _nameProduct;
  String _image;
  double _totalPrice;
  int _quantity;

  CartItem(this._nameProduct, this._image, this._totalPrice, this._quantity,
      this._idProdcut);

  factory CartItem.fromJson(Map<String, dynamic> json) {
    CartItem cartItem = new CartItem(
        json[DBHelper.columnNameProductCart],
        json[DBHelper.columnImage],
        json[DBHelper.columnTotalPriceCart],
        json[DBHelper.columnQuantity],
        json[DBHelper.columnIdProductF]);
    cartItem.id = json[DBHelper.columnId].toString();

    return cartItem;
  }

  void incrementQuantity() {
    _quantity = _quantity + 1;
    notifyListeners();
  }

  void reduceQuantity() {
    _quantity = _quantity - 1;
    notifyListeners();
  }

  String get id => _id;

  String get nameProduct => _nameProduct;

  int get quantity => _quantity;

  double get totalPrice => _totalPrice;

  String get image => _image;

  String get idProdcut => _idProdcut;

  set quantity(int value) {
    _quantity = value;
  }

  set totalPrice(double value) {
    _totalPrice = value;
  }

  set image(String value) {
    _image = value;
  }

  set nameProduct(String value) {
    _nameProduct = value;
  }

  set id(String value) {
    _id = value;
  }

  set idProdcut(String value) {
    _idProdcut = value;
  }
}
