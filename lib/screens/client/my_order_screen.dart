import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/widgets/button_common.dart';

class MyOrderScreen extends StatelessWidget {
  static const String routeName = '/my-order-screen';
  Widget buildItemOrder(BuildContext context){
    return   Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Row(
          children: <Widget>[
            Image.network(
              'https://img1.theiconic.com.au/rk9NZqAK1JFnDCaehXUmI1e-4b4=/fit-in/770x1160/filters:fill(ffffff,1):quality(90):format(jpeg)/https%3A%2F%2Fimages.prismic.io%2Ftheiconic-content-service%2F55ae3391-f207-49dd-a08b-3e5522306690_ShopAll.jpg',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('OrderId'),
                Text('Lotto.LTD'),
                Text(
                  '34.00\$',
                  style: TextStyle(color: Colors.blue),
                ),SizedBox(height: 10,),
               ButtonCommon(getTranslated(context, 'OrderAgain')),
                SizedBox(height: 10,)
              ],
            )
          ],
        ),
      ),
    );
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20,),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  getTranslated(context, 'MyOrders'),
                  style: const TextStyle(color: Colors.black, fontSize: 22),
                )),

            SizedBox(height: 40,),
            Column(children: List.generate(10, (index) => buildItemOrder(context)),)
          ],
        ),
      ),
    );
  }
}
