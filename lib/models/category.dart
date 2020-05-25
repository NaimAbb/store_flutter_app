class Category {
  String _id;
  String _name;

  Category(this._id, this._name);

  factory Category.fromJson(Map<String, dynamic> data) {
    return Category(data['id'], data['name']);
  }

  String get name => _name;

  String get id => _id;

  set name(String value) {
    _name = value;
  }

  set id(String value) {
    _id = value;
  }
}
