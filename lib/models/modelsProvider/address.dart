import 'package:flutter/material.dart';

class Address extends ChangeNotifier {
  int _id;
  String _name;
  int _idUser;
  String _addressLane;
  String _city;
  String _postalCode;
  String _phoneNumber;

  // for choose Only

  int _indexSelected = 0;

  Address(this._name, this._idUser, this._addressLane, this._city,
      this._postalCode, this._phoneNumber);

  factory Address.formJson(Map<dynamic, dynamic> data) {
    Address address = new Address(
        data['name'],
        data['idUser'],
        data['addressLane'],
        data['city'],
        data['postalCode'],
        data['phoneNumber']);
    address.id = data['id'];
    return address;
  }

  void changeValueSelected(int value){
    _indexSelected = value;
    notifyListeners();
  }




  int get indexSelected => _indexSelected;

  int get id => _id;

  String get name => _name;

  String get phoneNumber => _phoneNumber;

  String get postalCode => _postalCode;

  String get city => _city;

  String get addressLane => _addressLane;

  int get idUser => _idUser;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  set postalCode(String value) {
    _postalCode = value;
  }

  set city(String value) {
    _city = value;
  }

  set addressLane(String value) {
    _addressLane = value;
  }

  set idUser(int value) {
    _idUser = value;
  }

  set name(String value) {
    _name = value;
  }

  set id(int value) {
    _id = value;
  }
}
