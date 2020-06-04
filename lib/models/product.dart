import 'package:store_flutter_app/db/db_helper.dart';

class Product {
  String _id;
  String _name;
  double _price;
  int _idCategory;
  String _description;
  String _image;

  Product(this._name, this._price, this._idCategory, this._description);

  factory Product.fromJson(Map<String, dynamic> json) {
    Product product = new Product(
        json[DBHelper.columnName],
        json[DBHelper.columnPriceProduct],
        json[DBHelper.columnIdCategoryProduct],
        json[DBHelper.columnDuscriptionProduct]);
    product.id = json[DBHelper.columnId].toString();
    product.image = json[DBHelper.columnImage];

    return product;
  }

  String get name => _name;

  double get price => _price;

  String get description => _description;

  int get idCategory => _idCategory;

  String get id => _id;

  String get image => _image;

  set description(String value) {
    _description = value;
  }

  set idCategory(int value) {
    _idCategory = value;
  }

  set price(double value) {
    _price = value;
  }

  set name(String value) {
    _name = value;
  }

  set id(String value) {
    _id = value;
  }

  set image(String value) {
    _image = value;
  }
}
