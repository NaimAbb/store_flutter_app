import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/models/order_merchant.dart';
import 'package:store_flutter_app/widgets/button_common.dart';

class OrderDetailsScreen extends StatelessWidget {
  static const String routeName = '/order-details-screen';

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context).settings.arguments as OrderMerchant;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  getTranslated(context, 'OrderDetails'),
                  style: const TextStyle(color: Colors.black, fontSize: 22),
                )),
            SizedBox(
              height: 40,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Client Name',
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                )),
            SizedBox(
              height: 5,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  data.clientName,
                  style: const TextStyle(fontSize: 16),
                )),
            SizedBox(
              height: 60,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Address lane',
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                )),
            SizedBox(
              height: 5,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  data.address,
                  style: const TextStyle(fontSize: 16),
                )),
            SizedBox(
              height: 60,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Product List',
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                )),
            SizedBox(
              height: 20,
            ),
            Column(
              children: data.products.map((product) {
                return Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: <Widget>[
                        Image.memory(
                          base64Decode(product.image),
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          product.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Spacer(),
                        Text(
                          '\$' + product.price.toString(),
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold , fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,)
                ],);
              }).toList(),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
          margin: const EdgeInsets.only(bottom: 20),
          height: 50,
          child: ButtonCommon(getTranslated(context, 'Accept'))),
    );
  }
}
