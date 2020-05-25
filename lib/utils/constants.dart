import 'package:store_flutter_app/localStorage/shared_preferences_local.dart';

class Constants {
  static SharedPreferencesLocal sharedPreferencesLocal;

  static const bool SHARED_IS_LOGIN_DEFAULT_VALUE = false;
  static const String SHARED_USER_ID_DEFAULT_VALUE = '-1';

  static const String SHARED_IS_LOGIN = 'isLogin';
  static const String SHARED_USER_ID = 'userId';
  static const String SHARED_TYPE_ACCOUNT = 'typeAccount';
}
