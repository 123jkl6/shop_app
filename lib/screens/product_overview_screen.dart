import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/products_grid.dart';

import "../providers/products_provider.dart";

import "./carts_screen.dart";
import "../model/product.dart";
import "../model/cart.dart";
import "../widgets/product_item.dart";
import "../widgets/badge.dart";
import "../widgets/app_drawer.dart";

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductOverviewScreen();
  }
}

class _ProductOverviewScreen extends State {
  var showOnlyFavorites = false;
  var _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    //don't listen during initState
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text("Shop App"),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only Favorites"),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.All,
              ),
            ],
            onSelected: (FilterOptions value) {
              print(value);
              setState(() {
                if (value == FilterOptions.Favorites) {
                  //filter favorite;
                  showOnlyFavorites = true;
                } else {
                  showOnlyFavorites = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartsScreen.routeName);
              },
            ),
            builder: (_, cartData, child) => Badge(
              //icon button does not change
              child: child,
              value: cartData.itemCount.toString(),
              color: Colors.purple,
            ),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(showOnlyFavorites: showOnlyFavorites),
      drawer: AppDrawer(),
    );
    return scaffold;
  }
}
