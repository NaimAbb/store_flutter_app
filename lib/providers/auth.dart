import 'package:flutter/material.dart';
import 'package:store_flutter_app/db/db_helper.dart';
import 'package:store_flutter_app/models/user.dart';

class Auth extends ChangeNotifier {
  final _db = DBHelper();

  Future<void> signUp(
      {@required String name,
      @required String email,
      String type,
      @required String password}) async {
    try {
      User user =
          new User(name, email, type == 'Client' ? Type.Client : Type.Merchant);
      bool existResult = await _db.searchAboutEmail(email);
      if (!existResult) {
        int responce = await _db.addUser(user, password);
        if (responce == 1) {
          notifyListeners();
        } else {
          throw Exception;
        }
      } else {
        print('Exist');
      }
    } catch (error) {
      throw error;
    }
  }
}
