import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
//  WidgetsFlutterBinding.ensureInitialized();
  // await _getLang();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
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
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: Auth())],
      child: MaterialApp(
        localeResolutionCallback: (deviceLocale, supportedLocales) {
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
        home: SignInScreen(),
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
          DetailsProductScreen.routeName: (_) => DetailsProductScreen()
        },
      ),
    );
  }
}
