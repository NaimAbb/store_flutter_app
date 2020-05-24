import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/screens/client/address_screen.dart';
import 'package:store_flutter_app/widgets/button_common.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart-screen';

  @override
  State<StatefulWidget> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {


  Widget _buildItemCart(){
    return   Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Row(
          children: <Widget>[
            Image.network(
              'https://img1.theiconic.com.au/rk9NZqAK1JFnDCaehXUmI1e-4b4=/fit-in/770x1160/filters:fill(ffffff,1):quality(90):format(jpeg)/https%3A%2F%2Fimages.prismic.io%2Ftheiconic-content-service%2F55ae3391-f207-49dd-a08b-3e5522306690_ShopAll.jpg',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Womman t-shirt'),
                Text('Lotto.LTD'),
                Text(
                  '34.00\$',
                  style: TextStyle(color: Colors.blue),
                ),SizedBox(height: 10,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 30,
                  width: 90,
                  color: Colors.grey[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text('-' , style: TextStyle(fontSize: 20),), Text('1' , style: TextStyle(fontSize: 17),), Text('+' , style: TextStyle(fontSize: 20),)],
                  ),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  getTranslated(context, 'Cart'),
                  style: const TextStyle(color: Colors.black, fontSize: 25),
                )),SizedBox(height: 20,),
            _buildItemCart(),
            _buildItemCart(),
            _buildItemCart(),
            _buildItemCart(),
            _buildItemCart(),
            _buildItemCart(),
            _buildItemCart(),
          ],
        ),
      ),
      bottomSheet: Container(
          margin: const EdgeInsets.only(bottom: 10 , top: 10),
          height: 50,
          child: ButtonCommon(getTranslated(context, 'Continue') , onPress: (){
            Navigator.of(context).pushNamed(AddressScreen.routeName);
          },)),
    );
  }
}
