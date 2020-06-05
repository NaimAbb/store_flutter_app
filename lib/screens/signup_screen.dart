import 'package:flutter/material.dart';
import 'package:store_flutter_app/exceptions/email_exist_exception.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/screens/client/client_home_screen.dart';
import 'package:store_flutter_app/screens/merchant/merchant_home_screen.dart';
import 'package:store_flutter_app/widgets/button_common.dart';
import 'package:provider/provider.dart';
import 'package:store_flutter_app/providers/auth.dart';
import 'package:store_flutter_app/widgets/dialog_progress_widget.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/sign-up-screen';

  @override
  State<StatefulWidget> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  Auth _auth;

  final _fromState = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  String _typeUser;
  bool _emailExist = false;
  final String _patternEmail =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  @override
  void initState() {
    super.initState();
    _auth = Provider.of<Auth>(context, listen: false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _signUpBtn() async {
    _emailExist = false;
    bool result = _fromState.currentState.validate();
    if (!result) return;
    try {
      _showProgressDialog();
      await _auth.signUp(
          name: _nameController.text,
          email: _emailController.text,
          type: _typeUser,
          password: _passwordController.text);
      Navigator.of(context).pop();
      if (_typeUser == 'Client') {
        Navigator.of(context).pushReplacementNamed(ClientHomeScreen.routeName);
      } else {
        Navigator.of(context)
            .pushReplacementNamed(MerchantHomeScreen.routeName);
      }
    } on EmailExistException catch (error) {
      Navigator.of(context).pop();
      _emailExist = true;
      _fromState.currentState.validate();
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
                    getTranslated(context, 'SignUp'),
                    style: const TextStyle(color: Colors.black, fontSize: 22),
                  )),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_emailFocusNode),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return getTranslated(context, 'PleaseEnterName');
                    }
                    return null;
                  },
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: getTranslated(context, 'Name')),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordFocusNode),
                  textInputAction: TextInputAction.next,
                  focusNode: _emailFocusNode,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return getTranslated(context, 'PleaseEnterEmail');
                    }
                    if (!RegExp(_patternEmail).hasMatch(val)) {
                      return getTranslated(context, 'PleaseEnterValidEmail');
                    }
                    if (_emailExist) {
                      return getTranslated(context, 'EmailExist');
                    }
                    return null;
                  },
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
                  textInputAction: TextInputAction.done,
                  focusNode: _passwordFocusNode,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return getTranslated(context, 'PleaseEnterPassword');
                    }
                    if (val.length < 6) {
                      return getTranslated(context, 'MorePassword');
                    }
                    return null;
                  },
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: getTranslated(context, 'Password'),
                      suffixIcon: Icon(Icons.remove_red_eye)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonFormField<String>(
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return getTranslated(context, 'PleaseEnterType');
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: getTranslated(context, 'Type'),
                    hintStyle: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      child: Text('Client'),
                      value: 'Client',
                    ),
                    DropdownMenuItem(
                      child: Text('Merchant'),
                      value: 'Merchant',
                    )
                  ],
                  onChanged: (val) {
                    _typeUser = val;
                  },
                ),
              ),
//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 10),
//              child: TextFormField(
//                decoration:
//                    InputDecoration(labelText: getTranslated(context, 'Type')),
//              ),
//            ),
              SizedBox(
                height: 30,
              ),
              ButtonCommon(
                getTranslated(context, 'SignUp'),
                onPress: () {
                  _signUpBtn();
                },
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(getTranslated(context, 'AlreadyAccount')),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(getTranslated(context, 'SignIn')))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
