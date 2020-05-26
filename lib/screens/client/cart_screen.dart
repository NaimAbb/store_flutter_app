import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/screens/client/address_screen.dart';
import 'package:store_flutter_app/widgets/button_common.dart';
import 'package:provider/provider.dart';
import 'package:store_flutter_app/providers/client.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart-screen';

  @override
  State<StatefulWidget> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  Client _client;

  bool _isFirst = true;
  bool _isLoading = true;

  Widget _buildItemCart(String image, String title, int amount , double price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Row(
          children: <Widget>[
            Image.memory(
              base64Decode(image),
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title),
                Text('Lotto.LTD'),
                Text(
                  '${price}\$',
                  style: TextStyle(color: Colors.blue),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 30,
                  width: 90,
                  color: Colors.grey[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '-',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        amount.toString(),
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        '+',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _getCarts() async {
    try {
      await _client.getAllItemsFromCart();
      _isLoading = false;
    } catch (error) {}
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirst) {
      _client = Provider.of<Client>(context);
      _getCarts();
    }
    _isFirst = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        getTranslated(context, 'Cart'),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 25),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: _client.carts.map((item) {
                      return _buildItemCart(
                          item.image, item.nameProduct, item.quantity , item.totalPrice);
                    }).toList(),
                  ),
                ],
              ),
            ),
      bottomSheet: Container(
          margin: const EdgeInsets.only(bottom: 10, top: 10),
          height: 50,
          child: ButtonCommon(
            getTranslated(context, 'Continue'),
            onPress: () {
              Navigator.of(context).pushNamed(AddressScreen.routeName);
            },
          )),
    );
  }
}
