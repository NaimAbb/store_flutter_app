
enum Type { Client, Merchant }

class User {
  String _id;
  String _name;
  String _email;
  Type _type;

  User(this._name, this._email, this._type);

  String get name => _name;

  String get email => _email;


  String get id => _id;

  Type get type => _type;

  set type(Type value) {
    _type = value;
  }

  set email(String value) {
    _email = value;
  }


  set id(String value) {
    _id = value;
  }

  set name(String value) {
    _name = value;
  }
}
