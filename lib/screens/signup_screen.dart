import 'package:flutter/material.dart';
import 'package:store_flutter_app/db/db_helper.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/models/User.dart';
import 'package:store_flutter_app/widgets/button_common.dart';
import 'package:provider/provider.dart';
import 'package:store_flutter_app/providers/auth.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/sign-up-screen';

  @override
  State<StatefulWidget> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {

  Auth _auth ;
  final _fromState = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  String _typeUser;

  final String _patternEmail =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";


  @override
  void initState() {
    super.initState();
    _auth = Provider.of<Auth>(context , listen: false);
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
    bool result = _fromState.currentState.validate();
    if (!result) return;
    final db = DBHelper();
    User user = new User(_nameController.text, _emailController.text,
        _typeUser == 'Client' ? Type.Client : Type.Merchant);
    bool existResult = await db.searchAboutEmail(_emailController.text);
    if (!existResult){
      int responce = await db.addUser(user, _passwordController.text);
      final users = await db.getUsers();
      users.forEach((element) {
        print(element.email);
      });
    }else{
      print('Exist');
    }

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
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_emailFocusNode),
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
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
                  textInputAction: TextInputAction.next,
                  focusNode: _emailFocusNode,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return getTranslated(context, 'PleaseEnterEmail');
                    }
                    if (!RegExp(_patternEmail).hasMatch(val)) {
                      return getTranslated(context, 'PleaseEnterValidEmail');
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
                onPress: (){
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
