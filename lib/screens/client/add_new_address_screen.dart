import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/models/modelsProvider/address.dart';
import 'package:store_flutter_app/utils/constants.dart';
import 'package:store_flutter_app/widgets/button_common.dart';
import 'package:provider/provider.dart';
import 'package:store_flutter_app/providers/client.dart';

class AddNewAddressScreen extends StatefulWidget {
  static const String routeName = '/add-new-address-screen';

  @override
  State<StatefulWidget> createState() {
    return _AddNewAddressScreenState();
  }
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  Client _client;

  bool _isFirst = true;
  GlobalKey<FormState> _formState = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _addressLaneController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  FocusNode _addressLaneFocusNode = FocusNode();
  FocusNode _cityFocusNode = FocusNode();
  FocusNode _postalCodeFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _addressLaneController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _phoneNumberController.dispose();
    _addressLaneFocusNode.dispose();
    _cityFocusNode.dispose();
    _postalCodeFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    bool _result = _formState.currentState.validate();
    if (!_result) return;

    try {
      Address address = new Address(
          _nameController.text,
          int.parse(Constants.sharedPreferencesLocal.getUserId()),
          _addressLaneController.text,
          _cityController.text,
          _postalCodeController.text,
          _phoneNumberController.text);

      await _client.addAddress(address);
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: getTranslated(context, 'AddressAdded'),
          toastLength: Toast.LENGTH_SHORT);
      Navigator.of(context).pop();
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  void didChangeDependencies() {
    if (_isFirst) {
      _client = Provider.of<Client>(context, listen: false);
    }
    _isFirst = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formState,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  getTranslated(context, 'CreateAddress'),
                  style: const TextStyle(color: Colors.black, fontSize: 22),
                )),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return getTranslated(context, 'PleaseFillThisField');
                  }
                  return null;
                },
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_addressLaneFocusNode),
                textInputAction: TextInputAction.next,
                controller: _nameController,
                decoration:
                    InputDecoration(labelText: getTranslated(context, 'Name')),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return getTranslated(context, 'PleaseFillThisField');
                  }
                  return null;
                },
                focusNode: _addressLaneFocusNode,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_cityFocusNode),
                textInputAction: TextInputAction.next,
                controller: _addressLaneController,
                decoration: InputDecoration(
                    labelText: getTranslated(context, 'AddressLane')),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return getTranslated(context, 'PleaseFillThisField');
                  }
                  return null;
                },
                focusNode: _cityFocusNode,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_postalCodeFocusNode),
                textInputAction: TextInputAction.next,
                controller: _cityController,
                decoration:
                    InputDecoration(labelText: getTranslated(context, 'City')),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return getTranslated(context, 'PleaseFillThisField');
                  }
                  return null;
                },
                focusNode: _postalCodeFocusNode,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_phoneNumberFocusNode),
                textInputAction: TextInputAction.next,
                controller: _postalCodeController,
                decoration: InputDecoration(
                    labelText: getTranslated(context, 'PostalCode')),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return getTranslated(context, 'PleaseFillThisField');
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                focusNode: _phoneNumberFocusNode,
                textInputAction: TextInputAction.done,
                controller: _phoneNumberController,
                decoration: InputDecoration(
                    labelText: getTranslated(context, 'PhoneNumber')),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ButtonCommon(
              getTranslated(context, 'AddAddress'),
              onPress: _saveAddress,
            ),
          ],
        ),
      ),
    );
  }
}
