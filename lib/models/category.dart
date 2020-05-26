class Category {
  String _id;
  String _name;
  String _imageUrl;

  Category(this._id, this._name, this._imageUrl);

  factory Category.fromJson(Map<String, dynamic> data) {
    return Category(data['id'].toString(), data['name'], data['imageUrl']);
  }

  String get name => _name;

  String get id => _id;

  String get imageUrl => _imageUrl;

  set name(String value) {
    _name = value;
  }

  set id(String value) {
    _id = value;
  }

  set imageUrl(String value) {
    _imageUrl = value;
  }
}
