import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/models/modelsProvider/address.dart';
import 'package:store_flutter_app/screens/client/add_new_address_screen.dart';
import 'package:store_flutter_app/screens/client/my_order_screen.dart';
import 'package:store_flutter_app/utils/constants.dart';
import 'package:store_flutter_app/widgets/button_common.dart';
import 'package:store_flutter_app/providers/client.dart';
import 'package:provider/provider.dart';

List<Address> _allAddressNow = [];

bool get isSelected {
  return _allAddressNow.any((element) => element.indexSelected != 0);
}

// ignore: must_be_immutable
class AddressScreen extends StatelessWidget {
  static const String routeName = '/address-screen';

  bool isFirst = true;

  Future<void> confirmBtn(Client client, BuildContext context) async {
    if (_allAddressNow.isNotEmpty && !isSelected) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: getTranslated(context, 'MustAddAddress'));
      return;
    }
    if (_allAddressNow.isEmpty) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: getTranslated(context, 'MustAddAddress'));
      return;
    }
    bool result = false;
    _allAddressNow.forEach((element) {
      if (element.indexSelected != 0) {
        result = true;
        return;
      }
    });
    if (!result) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: getTranslated(context, 'MustAddAddress'));
      return;
    }

    Address address =
        _allAddressNow.firstWhere((element) => element.indexSelected != 0);
    await client.addOrder(
        Constants.sharedPreferencesLocal.getUserId(), address.id);
    Navigator.of(context).pushNamed(MyOrderScreen.routeName, arguments: 1);
  }

  @override
  Widget build(BuildContext context) {
    //   if (isFirst) {
    final client = Provider.of<Client>(context, listen: false);
    client.getAllAddressForUser(Constants.sharedPreferencesLocal.getUserId());
    //}
    //   isFirst = false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Selector<Client, List<Address>>(
                builder: (_, List<Address> getAllAddress, __) {
                  if (getAllAddress.isEmpty) {
                    return Center(
                      child: Text(
                        getTranslated(context, 'NoAddressAdded'),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  return ListView(
                    children: getAllAddress.map((address) {
                      _allAddressNow.add(address);
                      return Column(
                        children: <Widget>[
                          ChangeNotifierProvider.value(
                            value: address,
                            child: _ItemAddress(address),
                          ),
                          SizedBox(
                            height: 35,
                          )
                        ],
                      );
                    }).toList(),
                  );
                },
                selector: (_, value) => value.getAllAddress),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddNewAddressScreen.routeName);
            },
            child: Text(
              getTranslated(context, 'AddAddress'),
              style: TextStyle(color: Colors.lightBlue[300]),
            ),
          ),
          ButtonCommon(getTranslated(context, 'Confirm'), onPress: () {
            confirmBtn(client, context);
          }),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

class _ItemAddress extends StatelessWidget {
  final Address address;

  _ItemAddress(this.address);

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<Address>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(address.name),
            Text(address.city),
            Text(address.phoneNumber),
          ],
        ),
        Selector<Address, String>(
            builder: (_, String indexSelected, __) {
              return Radio(
                  value: address.id,
                  groupValue: indexSelected,
                  onChanged: (val) {
                    _allAddressNow.forEach((element) {
                      if (element.id != address.id) {
                        element.changeValueSelected('');
                      }
                    });
                    addressProvider.changeValueSelected(val);
                  });
            },
            selector: (_, value) => value.indexSelected)
      ],
    );
  }
}
