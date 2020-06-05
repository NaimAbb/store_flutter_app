import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:store_flutter_app/models/user.dart';
import 'localization/localization.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/merchant/merchant_home_screen.dart';
import 'screens/merchant/new_product_screen.dart';
import 'screens/merchant/orders_screen.dart';
import 'screens/merchant/order_details_screen.dart';
import 'screens/client/client_home_screen.dart';
import 'screens/client/cart_screen.dart';
import 'screens/client/address_screen.dart';
import 'screens/client/add_new_address_screen.dart';
import 'screens/client/my_order_screen.dart';
import 'screens/client/details_product_screen.dart';
import 'package:provider/provider.dart';
import 'providers/auth.dart';
import 'utils/constants.dart';
import 'localStorage/shared_preferences_local.dart';
import 'providers/merchant.dart';
import 'providers/client.dart';
import 'screens/client/order_details_client_screen.dart';

Locale locale;

Future<Map<String, dynamic>> _init() async {
  Map<String, dynamic> data = {};
  Constants.sharedPreferencesLocal = await SharedPreferencesLocal.getInstance();
  if (Constants.sharedPreferencesLocal.getIsLogin()) {
    print(Constants.sharedPreferencesLocal.getTypeAccount() );
    if (Constants.sharedPreferencesLocal.getTypeAccount() == Type.Client.toString()) {
      data['isLogin'] = true;
      data['type'] = 'Client';
      print('---------');
      locale = await Constants.sharedPreferencesLocal.getLang();
    } else {
      data['isLogin'] = true;
      data['type'] = 'Merchant';
      locale = await Constants.sharedPreferencesLocal.getLang();
    }
  } else {
    data['isLogin'] = false;
  }
  return data;

  // Helpers.changeAppLang(AppShared.sharedPreferencesController.getAppLang());
}

//Locale locale;
//
//Future<void> _getLang() async {
//  final sharedPreferences = await SharedPreferences.getInstance();
//  String languageCode = sharedPreferences.getString('languageCode') ?? null;
//  String countryCode = sharedPreferences.getString('countryCode') ?? null;
//  if (languageCode != null && countryCode != null)
//    locale = new Locale(languageCode, countryCode);
//}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await _getLang();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final data = await _init();
  runApp(MyApp(data));
}

class MyApp extends StatefulWidget {
  final Map<String, dynamic> data;

  MyApp(this.data);

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  // Locale _locale = locale;
  Locale _locale = locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Merchant()),
        ChangeNotifierProvider.value(value: Client()),
      ],
      child: MaterialApp(
        localeResolutionCallback: (deviceLocale, supportedLocales){
          // return Locale('ar', 'AE');
          for (var locale in supportedLocales) {
            if (locale != null &&
                deviceLocale != null &&
                locale.languageCode == deviceLocale.languageCode &&
                locale.countryCode == deviceLocale.countryCode) {
              return deviceLocale;
            }
          }
          return supportedLocales.first;
        },
        locale: _locale,
        title: 'Shop App',
        supportedLocales: [
          Locale('en', 'US'),
          Locale('ar', 'AE'),
        ],
        localizationsDelegates: [
          Localization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        debugShowCheckedModeBanner: false,
        home: widget.data['isLogin']
            ? widget.data['type'] == 'Client'
                ? ClientHomeScreen()
                : MerchantHomeScreen()
            : SignInScreen(),
        routes: {
          SignUpScreen.routeName: (_) => SignUpScreen(),
          MerchantHomeScreen.routeName: (_) => MerchantHomeScreen(),
          NewProductScreen.routeName: (_) => NewProductScreen(),
          OrdersScreen.routeName: (_) => OrdersScreen(),
          OrderDetailsScreen.routeName: (_) => OrderDetailsScreen(),
          ClientHomeScreen.routeName: (_) => ClientHomeScreen(),
          CartScreen.routeName: (_) => CartScreen(),
          AddressScreen.routeName: (_) => AddressScreen(),
          AddNewAddressScreen.routeName: (_) => AddNewAddressScreen(),
          MyOrderScreen.routeName: (_) => MyOrderScreen(),
          DetailsProductScreen.routeName: (_) => DetailsProductScreen(),
          OrderDetailsClientScreen.routeName : (_) => OrderDetailsClientScreen()
        },
      ),
    );
  }
}
