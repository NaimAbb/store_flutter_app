import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/screens/client/client_home_screen.dart';
import 'package:store_flutter_app/screens/signup_screen.dart';
import 'package:store_flutter_app/widgets/button_common.dart';
import 'package:store_flutter_app/db/db_helper.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInScreenState();
  }
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  getTranslated(context, 'SignIn'),
                  style: const TextStyle(color: Colors.black, fontSize: 22),
                )),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                decoration:
                    InputDecoration(labelText: getTranslated(context, 'Email')),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.remove_red_eye),
                    labelText: getTranslated(context, 'Password')),
              ),
            ),
            SizedBox(
              height: 30,
            ),

            ButtonCommon( getTranslated(context, 'SignIn') , onPress: ()async{
             DBHelper.dbInstance;
            //  Navigator.of(context).pushNamed(ClientHomeScreen.routeName);
            },),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(getTranslated(context, 'NoAccount')),
                FlatButton(onPressed: (){
                  Navigator.of(context).pushNamed(SignUpScreen.routeName);
                }, child: Text(getTranslated(context, 'SignUp')))
              ],
            )
          ],
        ),
      ),
    );
  }
}
