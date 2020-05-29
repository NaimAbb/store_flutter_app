import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/screens/client/my_order_screen.dart';
import 'package:provider/provider.dart';
import 'package:store_flutter_app/providers/auth.dart';
import 'package:store_flutter_app/screens/signin_screen.dart';

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
                await Provider.of<Auth>(context, listen: false).signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => SignInScreen()));
              },
              title: Text(
                'SignOut',
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
