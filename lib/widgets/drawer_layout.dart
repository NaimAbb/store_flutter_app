import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/screens/client/my_order_screen.dart';
import 'package:provider/provider.dart';
import 'package:store_flutter_app/providers/auth.dart';
import 'package:store_flutter_app/screens/signin_screen.dart';
import 'package:store_flutter_app/utils/constants.dart';

import '../main.dart';

class DrawerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: LayoutBuilder(builder: (_, constraint) {
        return Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Align(
                alignment: AlignmentDirectional.bottomStart,
                child: CircleAvatar(
                  radius: 35,
                ),
              ),
              width: constraint.maxWidth,
              height: constraint.maxHeight * 0.2,
              color: Theme.of(context).splashColor,
            ),
            SizedBox(
              height: constraint.maxHeight * 0.03,
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(MyOrderScreen.routeName);
              },
              title: Text(
                getTranslated(context, 'MyOrders'),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.shopping_basket),
            ),
            ListTile(
              onTap: () async {
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
                                  MyApp.setLocale(context, Locale('ar', 'AE'));
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text('English'),
                                onPressed: () async {
                                  await Constants.sharedPreferencesLocal
                                      .setLang('en', 'US');

                                  MyApp.setLocale(context, Locale('en', 'US'));
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ));
              },
              title: Text(
                getTranslated(context, 'Language'),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.language),
            ),
            ListTile(
              onTap: () async {
                await Provider.of<Auth>(context, listen: false).signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => SignInScreen()));
              },
              title: Text(
                getTranslated(context, 'SignOut'),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.exit_to_app),
            )
          ],
        );
      }),
    );
  }
}
