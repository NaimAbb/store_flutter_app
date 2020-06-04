import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/screens/merchant/new_product_screen.dart';
import 'package:store_flutter_app/screens/merchant/orders_screen.dart';
import 'package:store_flutter_app/screens/signin_screen.dart';
import 'package:store_flutter_app/utils/constants.dart';
import 'package:store_flutter_app/widgets/button_common.dart';
import 'package:provider/provider.dart';
import 'package:store_flutter_app/providers/auth.dart';
import '../../main.dart';

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
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                FlatButton(
                                  child: Text('عربي'),
                                  onPressed: () async {
                                    await Constants.sharedPreferencesLocal
                                        .setLang('ar', 'AE');
                                    MyApp.setLocale(
                                        context, Locale('ar', 'AE'));
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text('English'),
                                  onPressed: () async {
                                    await Constants.sharedPreferencesLocal
                                        .setLang('en', 'US');

                                    MyApp.setLocale(
                                        context, Locale('en', 'US'));
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ));
                },
                child: Text(
                  getTranslated(context, 'Language'),
                  style: TextStyle(color: Colors.red),
                )),  SizedBox(
              height: 10,
            ),
            FlatButton(
                onPressed: () async {
                  await Provider.of<Auth>(context, listen: false).signOut();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => SignInScreen()));
                },
                child: Text(
                  getTranslated(context, 'SignOut'),
                  style: TextStyle(color: Colors.red),
                )),
          ],
        ),
      ),
    );
  }
}
