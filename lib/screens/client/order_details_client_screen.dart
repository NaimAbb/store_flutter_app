import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/models/product.dart';
import 'package:store_flutter_app/providers/client.dart';

class OrderDetailsClientScreen extends StatelessWidget {
  static const String routeName = '/order-details-client-screen';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final idOrder = ModalRoute.of(context).settings.arguments as int;
    Provider.of<Client>(context, listen: false).getDetailsForOrder(idOrder);
    return Scaffold(
        body: Column(
      children: <Widget>[
        Platform.isAndroid
            ? Container(
                width: double.infinity,
                height: mediaQuery.padding.top,
              )
            : Container(),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
          width: double.infinity,
          child: Text(
            '${getTranslated(context, 'OrderId')} :$idOrder',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
            child: Selector<Client, List<Product>>(
                builder: (_, List<Product> getDetailsOrderProducts, __) {
                  return ListView.builder(
                    itemBuilder: (_, index) {
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: <Widget>[
                                Image.memory(
                                  base64Decode(
                                      getDetailsOrderProducts[index].image),
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  getDetailsOrderProducts[index].name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Spacer(),
                                Text(
                                  '\$' +
                                      getDetailsOrderProducts[index]
                                          .price
                                          .toString(),
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    },
                    itemCount: getDetailsOrderProducts.length,
                  );
                },
                selector: (_, value) => value.getDetailsOrderProducts))
      ],
    ));
  }
}
