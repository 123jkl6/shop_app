import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/products_provider.dart";

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    print("Product Detail ID : "+productId);
    //do not need to rebuild when a product changes, because this is a new page. 
    //by default listen property is true. 
    final loadedProduct = Provider.of<Products>(context,listen: false).findProductById(productId);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Container(),
    );
  }
}
