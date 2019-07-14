import 'package:flutter/material.dart';
import "package:provider/provider.dart";

import "./screens/product_overview_screen.dart";
import "./screens/product_detail_screen.dart";
import "./screens/carts_screen.dart";

import "./providers/products_provider.dart";
import "./model/cart.dart";

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
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Shop App',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: "Lato",
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartsScreen.routeName:(ctx)=>CartsScreen(),
        },
      ),
    );
  }
}
