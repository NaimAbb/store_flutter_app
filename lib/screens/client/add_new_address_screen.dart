import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/widgets/button_common.dart';

class AddNewAddressScreen extends StatefulWidget {
  static const String routeName = '/add-new-address-screen';

  @override
  State<StatefulWidget> createState() {
    return _AddNewAddressScreenState();
  }
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(children: <Widget>[
        SizedBox(height: 20,),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              getTranslated(context, 'CreateAddress'),
              style: const TextStyle(color: Colors.black, fontSize: 22),
            )),
          SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            decoration:
            InputDecoration(labelText: getTranslated(context, 'Name')),
          ),
        ),
        SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            decoration:
            InputDecoration(labelText: getTranslated(context, 'AddressLane')),
          ),
        ),
        SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            decoration:
            InputDecoration(labelText: getTranslated(context, 'City')),
          ),
        ),
        SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            decoration:
            InputDecoration(labelText: getTranslated(context, 'PostalCode')),
          ),
        ),
        SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            decoration:
            InputDecoration(labelText: getTranslated(context, 'PhoneNumber')),
          ),
        ),
        SizedBox(height: 30,),
        ButtonCommon( getTranslated(context, 'AddAddress') , onPress: (){
        },),
      ],),
    );
  }
}
