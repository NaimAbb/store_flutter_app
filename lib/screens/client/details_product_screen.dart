import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';

class DetailsProductScreen extends StatelessWidget {
  static const String routeName = '/details-product-screen';

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
            SizedBox(
              height: 20,
            ),
            Image.network(
              'https://www.thefuss.co.uk/wp-content/uploads/2017/09/Must-have-New-Look-maternity-pieces.jpg',
              height: 200,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Muslim Form',
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                )),
            SizedBox(
              height: 10,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '\$42',
                  style: const TextStyle(color: Colors.grey, fontSize: 17),
                )),
            SizedBox(
              height: 30,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  getTranslated(context, 'Duscription'),
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                )),
            SizedBox(
              height: 7,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'asdjklasjdakldjalkdjaldjaldjkaldjaldjaldjasldjasldjasldjasldjasldjasldjaslkdjasldjasldjaldjaldjaldjasldjladjlasdjaldjaldjaljdlasjdl',
                  style: const TextStyle(color: Colors.black87, fontSize: 16),
                )),
          ],
        ),
      ),
      bottomSheet: Container(
        margin: const EdgeInsets.only(top: 10),
        height: 50,
        child: RaisedButton(
          onPressed: () {},
          padding: const EdgeInsets.all(0.0),
          child: Ink(
            decoration: const BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.lightBlue, Colors.blueAccent]),
            ),
            child: Container(
              padding: const EdgeInsets.all(15),
              constraints:
                  const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
              // min sizes for Material buttons
              alignment: Alignment.center,
              child: Text(
                getTranslated(context, 'BuyNow'),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
