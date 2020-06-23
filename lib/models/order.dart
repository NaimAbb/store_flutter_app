
class Order {
  String _id;
  double _totalPrice;
  String _image;

  Order(this._id, this._totalPrice, this._image);



  String get id => _id;

  double get totalPrice => _totalPrice;

  String get image => _image;

  set image(String value) {
    _image = value;
  }

  set totalPrice(double value) {
    _totalPrice = value;
  }

  set id(String value) {
    _id = value;
  }
}
