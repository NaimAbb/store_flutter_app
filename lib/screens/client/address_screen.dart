import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/screens/client/add_new_address_screen.dart';
import 'package:store_flutter_app/screens/client/my_order_screen.dart';
import 'package:store_flutter_app/widgets/button_common.dart';

class AddressScreen extends StatelessWidget {
  static const String routeName = '/address-screen';

  Widget buildItemAddress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Vharty iuemnd udk lsdko sjjca lasl'),
            Text('House number 147'),
            Text('street alermal'),
          ],
        ),
        Radio(value: false, groupValue: false, onChanged: (val) {})
      ],
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
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: ListView(
            children: <Widget>[
              buildItemAddress(),
              SizedBox(
                height: 35,
              ),
              buildItemAddress(),
            ],
          )),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddNewAddressScreen.routeName);
            },
            child: Text(
              getTranslated(context, 'AddAddress'),
              style: TextStyle(color: Colors.lightBlue[300]),
            ),
          ),
          ButtonCommon(getTranslated(context, 'Confirm') , onPress: (){
            Navigator.of(context).pushNamed(MyOrderScreen.routeName);
          },),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
