import 'package:flutter/material.dart';
import 'package:store_flutter_app/db/db_helper.dart';
import 'package:store_flutter_app/exceptions/email_exist_exception.dart';
import 'package:store_flutter_app/models/user.dart';
import 'package:store_flutter_app/utils/constants.dart';

class Auth extends ChangeNotifier {
  final _db = DBHelper();

  Future<User> signIn(
      {@required String email, @required String password}) async {
    final result = await _db.emailAndPasswordIsExist(email, password);
    if (result != null) {
      await _db.addCategories();
      await Constants.sharedPreferencesLocal.setUserId(result.id);
      await Constants.sharedPreferencesLocal.setIsLogin(true);
      await Constants.sharedPreferencesLocal
          .setTypeAccount(result.type.toString());
      return result;
    }

    return null;
  }

  Future<void> signUp(
      {@required String name,
      @required String email,
      @required String type,
      @required String password}) async {
    try {
      User user =
          new User(name, email, type == 'Client' ? Type.Client : Type.Merchant);
      bool existResult = await _db.searchAboutEmail(email);
      if (!existResult) {
        int responce = await _db.addUser(user, password);
        await Constants.sharedPreferencesLocal.setUserId(responce.toString());
        await Constants.sharedPreferencesLocal.setIsLogin(true);
        await Constants.sharedPreferencesLocal.setTypeAccount(type);
      } else {
        throw EmailExistException('Email is exist !');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> signOut()async{
    await Constants.sharedPreferencesLocal.clear();
  }
}
