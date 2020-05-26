class CartItem {
  String _id;
  int _idProdcut;
  String _nameProduct;
  String _image;
  double _totalPrice;
  int _quantity;

  CartItem(this._nameProduct, this._image, this._totalPrice, this._quantity , this._idProdcut);

  String get id => _id;

  String get nameProduct => _nameProduct;

  int get quantity => _quantity;

  double get totalPrice => _totalPrice;

  String get image => _image;


  int get idProdcut => _idProdcut;

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

  set idProdcut(int value) {
    _idProdcut = value;
  }


}
