import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/screens/client/cart_screen.dart';
import 'package:store_flutter_app/screens/client/client_home_screen.dart';
import 'package:store_flutter_app/screens/client/order_details_client_screen.dart';
import 'package:store_flutter_app/utils/constants.dart';
import 'package:store_flutter_app/widgets/button_common.dart';
import 'package:store_flutter_app/models/order.dart';
import 'package:provider/provider.dart';
import 'package:store_flutter_app/providers/client.dart';

class MyOrderScreen extends StatelessWidget {
  static const String routeName = '/my-order-screen';

  Widget buildItemOrder(
      BuildContext context, String image, String orderId, double totalPrice) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Row(
          children: <Widget>[
            Image.network(
             image,
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
                Text('$orderId'),
                Text('Lotto.LTD'),
                Text(
                  '$totalPrice\$',
                  style: TextStyle(color: Colors.blue),
                ),
                SizedBox(
                  height: 10,
                ),
                ButtonCommon(
                  getTranslated(context, 'Details'),
                  onPress: () {
                    Navigator.of(context).pushNamed(
                        OrderDetailsClientScreen.routeName,
                        arguments: orderId);
                  },
                ),
                SizedBox(
                  height: 10,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context).settings.arguments as int ?? 0;
    Provider.of<Client>(context, listen: false).getOrdersForClient(
        Constants.sharedPreferencesLocal.getUserId());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (data == 1) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  ClientHomeScreen.routeName,
                  ModalRoute.withName(CartScreen.routeName));
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  getTranslated(context, 'MyOrders'),
                  style: const TextStyle(color: Colors.black, fontSize: 22),
                )),
            SizedBox(
              height: 40,
            ),
            Selector<Client, List<Order>>(
                builder: (_, List<Order> getOrders, __) {
                  if (getOrders == null || getOrders.isEmpty) {
                    return Text(
                      getTranslated(context, 'NoOrder'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    );
                  }
                  return Column(
                    children: List.generate(
                        getOrders.length,
                        (index) => buildItemOrder(
                            context,
                            getOrders[index].image,
                            getOrders[index].id,
                            getOrders[index].totalPrice)),
                  );
                },
                selector: (_, value) => value.getOrders),
          ],
        ),
      ),
    );
  }
}
