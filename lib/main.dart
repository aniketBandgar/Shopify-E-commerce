import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';
import './providers/product_provider.dart';
import './screens/product_outlet_screen.dart';
import 'package:provider/provider.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, ProdutProvider>(
            create: (ctx) => ProdutProvider(null, []),
            update: (ctx, auth, priviousProduct) => ProdutProvider(auth.token,
                priviousProduct == null ? [] : priviousProduct.items),
          ),
          ChangeNotifierProvider(create: (ctx) => Cart()),
          ChangeNotifierProvider(create: (ctx) => Order())
        ],
        child: Consumer<Auth>(builder: (ctx, auth, _) {
          return MaterialApp(
            title: 'Shop_App',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              canvasColor: Colors.white,
              fontFamily: 'Lato',
            ),
            // initialRoute: '/',
            // home: auth.isAuth ? ProductOutletScreen() : AuthScreen(),
            initialRoute: auth.isAuth
                ? AuthScreen.routeName
                : ProductOutletScreen.routeName,
            routes: {
              // '/': (ctx) => ProductOutletScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
              ProductOutletScreen.routeName: (ctx) => ProductOutletScreen(),
              ProductDetailScreen.routename: (ctx) => ProductDetailScreen(),
              CartScreen.routName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          );
        }));
  }
}
