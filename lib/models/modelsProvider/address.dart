import 'package:flutter/material.dart';

class Address extends ChangeNotifier {
  String _id;
  String _name;
  String _idUser;
  String _addressLane;
  String _city;
  String _postalCode;
  String _phoneNumber;

  // for choose Only

  String _indexSelected = '';

  Address(this._name, this._idUser, this._addressLane, this._city,
      this._postalCode, this._phoneNumber);

  factory Address.formJson(Map<dynamic, dynamic> data , {String idAddress}) {
    Address address = new Address(
        data['name'],
        data['idUser'],
        data['addressLane'],
        data['city'],
        data['postalCode'],
        data['phoneNumber']);
    address.id = idAddress != null ? idAddress :data['id'];
    return address;
  }

  void changeValueSelected(String value){
    _indexSelected = value;
    notifyListeners();
  }




  String get indexSelected => _indexSelected;

  String get id => _id;

  String get name => _name;

  String get phoneNumber => _phoneNumber;

  String get postalCode => _postalCode;

  String get city => _city;

  String get addressLane => _addressLane;

  String get idUser => _idUser;

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

  set idUser(String value) {
    _idUser = value;
  }

  set name(String value) {
    _name = value;
  }

  set id(String value) {
    _id = value;
  }
}
