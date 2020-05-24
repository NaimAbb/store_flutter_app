import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/widgets/button_common.dart';

class NewProductScreen extends StatefulWidget {
  static const String routeName = '/new-product-screen';

  @override
  State<StatefulWidget> createState() {
    return _NewProductScreenState();
  }
}

class _NewProductScreenState extends State<NewProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: getTranslated(context, 'ProductName')),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: getTranslated(context, 'ProductPrice')),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: getTranslated(context, 'ProductCategory')),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: getTranslated(context, 'Duscription')),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            ButtonCommon(getTranslated(context, "PickImage")),
            SizedBox(height: 30,),
            ButtonCommon(getTranslated(context, 'AddProduct'))
          ],
        ),
      ),
    );
  }
}
