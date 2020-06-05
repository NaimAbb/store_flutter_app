import 'package:flutter/material.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/screens/client/client_home_screen.dart';
import 'package:store_flutter_app/screens/merchant/merchant_home_screen.dart';
import 'package:store_flutter_app/screens/signup_screen.dart';
import 'package:store_flutter_app/widgets/button_common.dart';
import 'package:store_flutter_app/widgets/dialog_progress_widget.dart';
import 'package:provider/provider.dart';
import 'package:store_flutter_app/providers/auth.dart';
import 'package:store_flutter_app/models/user.dart';
import 'package:store_flutter_app/widgets/error_dialog_widget.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInScreenState();
  }
}

class _SignInScreenState extends State<SignInScreen> {

  Auth _auth;


  final _fromState = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  FocusNode _passwordFocusNode = FocusNode();

  final String _patternEmail =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";


  @override
  void initState() {
    super.initState();
    _auth = Provider.of<Auth>(context , listen: false);
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _signInBtn() async {
    bool result = _fromState.currentState.validate();
    if (!result) return;
    try {
      _showProgressDialog();
      final existOrNot = await _auth.signIn(email: _emailController.text , password: _passwordController.text);
      Navigator.of(context).pop();
     if (existOrNot != null){
       if (existOrNot.type == Type.Client){
         Navigator.of(context).pushReplacementNamed(ClientHomeScreen.routeName);
       }else{
         Navigator.of(context).pushReplacementNamed(MerchantHomeScreen.routeName);
       }
     }else{
      showDialog(context: context , builder: (_) => ErrorDialogWidget('Email Or Password is Invalid!'));
     }

    } catch (error) {
      Navigator.of(context).pop();
    }
  }


  void _showProgressDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            content: DialogProgressWidget(),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _fromState,
        child: SingleChildScrollView(
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
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return getTranslated(context, 'PleaseEnterEmail');
                    }
                    if (!RegExp(_patternEmail).hasMatch(val)) {
                      return getTranslated(context, 'PleaseEnterValidEmail');
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordFocusNode),
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: getTranslated(context, 'Email')),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return getTranslated(context, 'PleaseEnterPassword');
                    }
                    return null;
                  },
                  focusNode: _passwordFocusNode,
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.remove_red_eye),
                      labelText: getTranslated(context, 'Password')),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ButtonCommon(
                getTranslated(context, 'SignIn'),
                onPress: () async {
                  _signInBtn();
                  //  Navigator.of(context).pushNamed(ClientHomeScreen.routeName);
                },
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(getTranslated(context, 'NoAccount')),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(SignUpScreen.routeName);
                      },
                      child: Text(getTranslated(context, 'SignUp')))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
