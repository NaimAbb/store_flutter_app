import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_flutter_app/utils/constants.dart';

class SharedPreferencesLocal {
  static Future<SharedPreferencesLocal> _instance;
  static SharedPreferences _sharedPreferences;
  static Completer<SharedPreferencesLocal> _completer;

  SharedPreferencesLocal._();

  static Future<SharedPreferencesLocal> getInstance() async {
    if (_instance != null) return _instance;
    _completer = Completer<SharedPreferencesLocal>();
    await _init();
    _completer.complete(SharedPreferencesLocal._());
    return _instance = _completer.future;
  }

  static Future<void> _init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  bool getIsLogin() {
    return _sharedPreferences.getBool(Constants.SHARED_IS_LOGIN) ??
        Constants.SHARED_IS_LOGIN_DEFAULT_VALUE;
  }

  Future<void> setIsLogin(bool isLogin) async {
    await _sharedPreferences.setBool(Constants.SHARED_IS_LOGIN, isLogin);
  }

  String getUserId() {
    return _sharedPreferences.getString(Constants.SHARED_USER_ID) ??
        Constants.SHARED_USER_ID_DEFAULT_VALUE;
  }

  // set the current user id.
  Future<void> setUserId(String userId) async {
    await _sharedPreferences.setString(Constants.SHARED_USER_ID, userId);
  }

  Future<void> setTypeAccount(String type) async {
    await _sharedPreferences.setString(Constants.SHARED_TYPE_ACCOUNT, type);
  }

  String getTypeAccount() {
    return _sharedPreferences.getString(Constants.SHARED_TYPE_ACCOUNT) ?? '';
  }

  Future<void> clear() async {
    await _sharedPreferences.clear();
  }
}
