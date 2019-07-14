import "package:flutter/material.dart";
import 'package:shop_app/widgets/products_grid.dart';

import "../model/product.dart";
import "../widgets/product_item.dart";

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductOverviewScreen();
  }
}

class _ProductOverviewScreen extends State {
  var showOnlyFavorites = false;
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
        ],
      ),
      body: ProductsGrid(showOnlyFavorites: showOnlyFavorites),
    );
    return scaffold;
  }
}
