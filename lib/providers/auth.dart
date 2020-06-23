import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_flutter_app/db/db_helper.dart';
import 'package:store_flutter_app/exceptions/email_exist_exception.dart';
import 'package:store_flutter_app/models/user.dart';
import 'package:store_flutter_app/utils/constants.dart';

class Auth extends ChangeNotifier {
  final _db = DBHelper();

  Future<User> signIn(
      {@required String email, @required String password}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    AuthResult authResult =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    Firestore firestore = Firestore.instance;
    CollectionReference crUser = firestore.collection('User');
    DocumentSnapshot documentSnapshot =
        await crUser.document(authResult.user.uid).get();

    if (documentSnapshot != null && documentSnapshot.data != null && documentSnapshot.data.isNotEmpty) {
      final type = documentSnapshot.data['type'] as int;

      User user = new User(
          documentSnapshot.data['name'],
          documentSnapshot.data['email'],
          type == 1 ? Type.Client : Type.Merchant);
      user.id = authResult.user.uid;
      await Constants.sharedPreferencesLocal.setUserId(authResult.user.uid);
      await Constants.sharedPreferencesLocal.setIsLogin(true);
      await Constants.sharedPreferencesLocal.setTypeAccount(
          user.type.toString());
      final result = await _db.emailAndPasswordIsExist(email, password);

      return user;
    }else{
      return null;
    }
//    if (result != null) {
//      print(result.type.toString());
//      await _db.addCategories();
//      await Constants.sharedPreferencesLocal.setUserId(result.id);
//      await Constants.sharedPreferencesLocal.setIsLogin(true);
//      await Constants.sharedPreferencesLocal
//          .setTypeAccount(result.type.toString());
//      return result;
//    }
//
//    return null;
  }

  Future<void> signUp(
      {@required String name,
      @required String email,
      @required String type,
      @required String password}) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      AuthResult authResult = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Firestore firestore = Firestore.instance;
      CollectionReference crUser = firestore.collection('User');
      User user =
          new User(name, email, type == 'Client' ? Type.Client : Type.Merchant);
      await crUser.document(authResult.user.uid).setData({
        'name': name,
        'email': email,
        'type': type == 'Client' ? 1 : 2,
        'id': authResult.user.uid
      });
      await Constants.sharedPreferencesLocal.setUserId(authResult.user.uid);
      await Constants.sharedPreferencesLocal.setIsLogin(true);
      await Constants.sharedPreferencesLocal
          .setTypeAccount(user.type.toString());

//      User user =
//          new User(name, email, type == 'Client' ? Type.Client : Type.Merchant);
//      bool existResult = await _db.searchAboutEmail(email);
//      if (!existResult) {
//        int responce = await _db.addUser(user, password);
//        await Constants.sharedPreferencesLocal.setUserId(responce.toString());
//        await Constants.sharedPreferencesLocal.setIsLogin(true);
//        await Constants.sharedPreferencesLocal.setTypeAccount(user.type.toString());
      //       await _db.addCategories();
//      } else {
//        throw EmailExistException('Email is exist !');
//      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await Constants.sharedPreferencesLocal.clear();
  }
}
