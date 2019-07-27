import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:shop_app/helpers/custom_route.dart'; 
import 'package:shop_app/screens/user_products_screen.dart';
import "../screens/orders_screen.dart";

import "../providers/auth.dart";

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("Hello Friend!"),
            //disallow goingback
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: () {
              Navigator.of(context).pushReplacement(CustomRoute(builder:(ctx)=>OrdersScreen()));
              //Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage products"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
           Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              //call pop to remove drawer before logging out to prevent transition error. 
              Navigator.of(context).pop();
              //calling pushReplacementNamed to prevent unexpected behavior when logging out. 
              Navigator.of(context).pushReplacementNamed("/");
              Provider.of<Auth>(context,listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
