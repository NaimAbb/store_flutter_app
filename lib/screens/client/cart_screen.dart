import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/models/modelsProvider/cart_item.dart';
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

  int count = 0;

  Widget _buildItemCart(String image, String title, int amount, double price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Row(
          children: <Widget>[
            Image.memory(
              base64Decode(image),
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title),
                Text(
                  '${price}\$',
                  style: TextStyle(color: Colors.blue),
                ),
                SizedBox(
                  height: 20,
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
                      InkWell(
                        onTap: () {
                          setState(() {
                            amount + 1;
                          });
                        },
                        child: Text(
                          '+',
                          style: TextStyle(fontSize: 20),
                        ),
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

  double total = 0;

  @override
  Widget build(BuildContext context) {
    total = 0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _client.carts.isEmpty
              ? Center(
                  child: Text('Empty'),
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
                            style: const TextStyle(
                                color: Colors.black, fontSize: 25),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: _client.carts.map((item) {
                          total += item.totalPrice * item.quantity;
                          return ChangeNotifierProvider.value(value: item,child: _CartItem(item, ValueKey(item.id)));
                        }).toList(),
                      ),
                    ],
                  ),
                ),
      bottomSheet: Container(
          margin: const EdgeInsets.only(bottom: 10, top: 10),
          height: 100,
          child: Column(
            children: <Widget>[
              Text('${getTranslated(context, 'TotalPrice')} : \$$total'),
              SizedBox(
                height: 10,
              ),
              ButtonCommon(
                getTranslated(context, 'Continue'),
                onPress: () {
                  Navigator.of(context).pushNamed(AddressScreen.routeName);
                },
              )
            ],
          )),
    );
  }
}

class _CartItem extends StatefulWidget {
  final CartItem cartItem;
  final Key key;

  const _CartItem(this.cartItem, this.key) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CartItemState();
  }
}

class _CartItemState extends State<_CartItem> {
  Client _client;
  bool _isFirst = true;
  int _amount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirst) {
      _client = Provider.of<Client>(context);
      _amount = widget.cartItem.quantity;
    }
    _isFirst = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Row(
          children: <Widget>[
            Image.network(
              widget.cartItem.image,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.cartItem.nameProduct),
                Text(
                  '${widget.cartItem.totalPrice}\$',
                  style: TextStyle(color: Colors.blue),
                ),
                SizedBox(
                  height: 20,
                ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 30,
        width: 90,
        color: Colors.grey[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () async{
                if (_amount > 1) {
                  _amount = _amount - 1;
                  await _client.reducingTheQuantity(
                      widget.cartItem.idProdcut);
                  await _client.getCount();
                  widget.cartItem.reduceQuantity();
                }
              },
              child: Text(
                '-',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Text(
              widget.cartItem.quantity.toString(),
              style: TextStyle(fontSize: 17),
            ),
            InkWell(
              onTap: () async{
                _amount = _amount + 1;
                await _client.addToCart(widget.cartItem);
                await _client.getCount();
                widget.cartItem.incrementQuantity();
              },
              child: Text(
                '+',
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      )
              ],
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                await _client.deleteItemFromCart(widget.cartItem.idProdcut);
                _client.getCount();
              },
            )
          ],
        ),
      ),
    );
    ;
  }
}
