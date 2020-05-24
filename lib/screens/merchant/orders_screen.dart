import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/screens/merchant/order_details_screen.dart';
import 'package:store_flutter_app/widgets/button_common.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders-screen';

  Widget itemOrder(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Womman t- shirt'),
            Text(
              'Lotto.LTD',
              style: TextStyle(color: Colors.grey),
            ),
            Text('43.00\$'),
            Text('Client Name'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text('City'), ButtonCommon('Details' , onPress: (){
                Navigator.of(context).pushNamed(OrderDetailsScreen.routeName);
              },)],
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
            itemOrder(context),
            itemOrder(context),
            itemOrder(context),
            itemOrder(context),
            itemOrder(context),
          ],
        ),
      ),
    );
  }
}
