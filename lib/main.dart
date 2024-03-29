import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/splash-screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import "./screens/product_overview_screen.dart";
import "./screens/product_detail_screen.dart";
import "./screens/carts_screen.dart";
import "./screens/orders_screen.dart";
import "./screens/auth-screen.dart";

import "./providers/auth.dart";
import "./providers/products_provider.dart";
import "./model/cart.dart";
import "./model/order.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // possible to have more than one provider in an app.
    //recommended to set it at the lowest level as possible
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          builder: (ctx, auth, previousProducts) => Products(
            previousProducts == null ? [] : previousProducts.items,
            token: auth.token,
            userId: auth.userId,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (ctx, auth, previousOrders) => Orders(
            previousOrders == null ? [] : previousOrders.orders,
            token: auth.token,
            userId: auth.userId,
          ),
        ),
      ],
      // use consumer to navigate between auth and main screen in MaterialApp
      child: Consumer<Auth>(
        builder: (ctx, authData, child) => MaterialApp(
          title: 'Shop App',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: "Lato",
              //global config for page transition animations
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android : CustomPageTransitionBuilder(),
                TargetPlatform.iOS : CustomPageTransitionBuilder(),
              })),
          home: authData.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartsScreen.routeName: (ctx) => CartsScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProduct.routeName: (ctx) => EditProduct(),
          },
        ),
      ),
    );
  }
}
