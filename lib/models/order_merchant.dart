import 'package:store_flutter_app/models/product.dart';

class OrderMerchant {
  String _idOrder;
  String _clientName;
  String _address;
  double _totalPrice;
  List<Product> _products;

  OrderMerchant(this._idOrder, this._clientName, this._address,
      this._totalPrice, this._products);

  String get idOrder => _idOrder;

  String get clientName => _clientName;

  String get address => _address;

  double get totalPrice => _totalPrice;

  List<Product> get products => _products;

  set products(List<Product> value) {
    _products = value;
  }

  set totalPrice(double value) {
    _totalPrice = value;
  }

  set address(String value) {
    _address = value;
  }

  set clientName(String value) {
    _clientName = value;
  }

  set idOrder(String value) {
    _idOrder = value;
  }
}
