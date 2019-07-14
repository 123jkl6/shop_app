import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/products_provider.dart";
import "../model/product.dart";
import "./product_item.dart";

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorites;

  ProductsGrid({this.showOnlyFavorites});

  @override
  Widget build(BuildContext context) {
    //only widgets which are listening to changes will rebuild.
    //i.e in this case //establish direct communication with provider.
    final productsData = Provider.of<Products>(context);
    List<Product> loadedProducts;
    if (showOnlyFavorites) {
      loadedProducts = productsData.getFavItems;
    } else {
      loadedProducts = productsData.items;
    }
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: loadedProducts.length,
      //use value constrcutor if provider is not dependent on context
      //memory management is handled internally, hence reduce memory leaks.
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedProducts[i],
        child: ProductItem(),
      ),
      // how grid should be structured
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
