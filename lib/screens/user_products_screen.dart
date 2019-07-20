import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product.dart';

import "./edit_product_screen.dart";

import "../providers/products_provider.dart";

class UserProductsScreen extends StatelessWidget {
  static final routeName = "user-products";

  Future<void> _refreshProducts(Products productsData) async {
    await productsData.fetchAndSetProducts(); 
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context,listen: true);
    print(productsData.items);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your products"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProduct.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh:()=>_refreshProducts(productsData),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, i) => Column(
              children: [
                UserProductItem(
                  id:productsData.items[i].id,
                  title: productsData.items[i].title,
                  imageUrl: productsData.items[i].imageUrl,
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
