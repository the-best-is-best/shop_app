import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/providers/cart.dart';
import 'package:flutter_app/providers/orders.dart';
import 'package:flutter_app/providers/products.dart';
import 'package:flutter_app/screens/auth_screen.dart';
import 'package:flutter_app/screens/splash_screen.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import '../screens/product_overview_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (ctx, authValue, previousProduct) => previousProduct
            ..getData(
              authValue.token,
              authValue.userId,
              previousProduct == null ? null : previousProduct.items,
            ),
        ),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders(),
            update: (ctx, authValue, previouOrders) => previouOrders
              ..getData(
                authValue.token,
                authValue.userId,
                previouOrders == null ? null : previouOrders.orders,
              )),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Shop App',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepPurple[300],
            fontFamily: 'Lato',
            canvasColor: Colors.deepPurple[300].withOpacity(1),
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, AsyncSnapshot authSnapShot) =>
                      authSnapShot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
        ),
      ),
    );
  }
}
