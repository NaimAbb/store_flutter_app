import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/models/order_merchant.dart';
import 'package:store_flutter_app/screens/merchant/order_details_screen.dart';
import 'package:store_flutter_app/utils/constants.dart';
import 'package:store_flutter_app/widgets/button_common.dart';
import 'package:provider/provider.dart';
import 'package:store_flutter_app/providers/merchant.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders-screen';

  Widget itemOrder(BuildContext context , OrderMerchant orderMerchant) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(orderMerchant.idOrder),
            Text('${orderMerchant.totalPrice}\$'),
            Text(orderMerchant.clientName),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(orderMerchant.address),
                ButtonCommon(
                  'Details',
                  onPress: () {
                    Navigator.of(context)
                        .pushNamed(OrderDetailsScreen.routeName , arguments: orderMerchant);
                  },
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
    Provider.of<Merchant>(context , listen: false).getOrdersForMerchant(int.parse(Constants.sharedPreferencesLocal.getUserId()));
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
                  getTranslated(context, 'Orders'),
                  style: const TextStyle(color: Colors.black, fontSize: 22),
                )),
            SizedBox(
              height: 20,
            ),
            Selector<Merchant , List<OrderMerchant>>(builder: (_ , List<OrderMerchant>getOrders , __){
              return Column(children: getOrders.map((order){
                return itemOrder(context , order);
              }).toList());
            }, selector: (_ , value) => value.getOrders),
          ],
        ),
      ),
    );
  }
}
