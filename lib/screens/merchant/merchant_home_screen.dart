import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/screens/merchant/new_product_screen.dart';
import 'package:store_flutter_app/screens/merchant/orders_screen.dart';
import 'package:store_flutter_app/screens/signin_screen.dart';
import 'package:store_flutter_app/widgets/button_common.dart';
import 'package:provider/provider.dart';
import 'package:store_flutter_app/providers/auth.dart';

class MerchantHomeScreen extends StatelessWidget {
  static const String routeName = '/merchant-home-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ButtonCommon(
              getTranslated(context, 'NewProduct'),
              onPress: () {
                Navigator.of(context).pushNamed(NewProductScreen.routeName);
              },
            ),
            SizedBox(
              height: 15,
            ),
            ButtonCommon(
              getTranslated(context, 'Orders'),
              onPress: () {
                Navigator.of(context).pushNamed(OrdersScreen.routeName);
              },
            ),
            SizedBox(
              height: 10,
            ),
            FlatButton(
                onPressed: () async {
                  await Provider.of<Auth>(context, listen: false).signOut();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => SignInScreen()));
                },
                child: Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.red),
                ))
          ],
        ),
      ),
    );
  }
}
