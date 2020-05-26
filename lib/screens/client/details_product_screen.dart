import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/models/cart_item.dart';
import 'package:store_flutter_app/models/product.dart';
import 'package:provider/provider.dart';
import 'package:store_flutter_app/providers/client.dart';

class DetailsProductScreen extends StatelessWidget {
  static const String routeName = '/details-product-screen';
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final dataProduct = ModalRoute.of(context).settings.arguments as Product;
    print(dataProduct.id);
    return Scaffold(
      key: _scaffoldState,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
         Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,children: <Widget>[
           Image.memory(
             base64Decode(dataProduct.image),
             height: 200,
             fit: BoxFit.fill,
           ),
           SizedBox(
             height: 15,
           ),
           Padding(
               padding: const EdgeInsets.symmetric(horizontal: 10),
               child: Text(
                 dataProduct.name,
                 style: const TextStyle(color: Colors.black, fontSize: 20),
               )),
           SizedBox(
             height: 10,
           ),
           Padding(
               padding: const EdgeInsets.symmetric(horizontal: 10),
               child: Text(
                 '\$${dataProduct.price}',
                 style: const TextStyle(color: Colors.grey, fontSize: 17),
               )),
           SizedBox(
             height: 30,
           ),
           Padding(
               padding: const EdgeInsets.symmetric(horizontal: 10),
               child: Text(
                 getTranslated(context, 'Duscription'),
                 style: const TextStyle(color: Colors.black, fontSize: 18),
               )),
           SizedBox(
             height: 7,
           ),
           Padding(
               padding: const EdgeInsets.symmetric(horizontal: 10),
               child: Text(
                 dataProduct.description,
                 style: const TextStyle(color: Colors.black87, fontSize: 16),
               )),
         ],),),
          Container(

            margin: const EdgeInsets.only(top: 10),
            height: 50,
            child: RaisedButton(
              onPressed: () async {
                CartItem cartItem = new CartItem(
                    dataProduct.name,
                    dataProduct.image,
                    dataProduct.price,
                    1,
                    int.parse(dataProduct.id));
                await Provider.of<Client>(context, listen: false)
                    .addToCart(cartItem);
                _scaffoldState.currentState.hideCurrentSnackBar();
                _scaffoldState.currentState.showSnackBar(SnackBar(content: Text('add success to cart') , ));
              },
              padding: const EdgeInsets.all(0.0),
              child: Ink(
                decoration: const BoxDecoration(
                  gradient:
                  LinearGradient(colors: [Colors.lightBlue, Colors.blueAccent]),
                ),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  constraints:
                  const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                  // min sizes for Material buttons
                  alignment: Alignment.center,
                  child: Text(
                    getTranslated(context, 'BuyNow'),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
