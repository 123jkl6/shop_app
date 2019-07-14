import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../model/product.dart";

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    //above is commented out to demonstrate Consumer use.
    //using Provider results in build method being called;
    //using Consumer onlu rebuilds affected widget branch
    //works well in a grid.
    print("product item build ID : "+product.id);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context)
                .pushNamed("/product-detail", arguments: product.id);
          },
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black38,
          //child argument can be something that does not change
          leading: Consumer<Product>(
            //child property can be passed here. 
            //child is replaced with underscore to ignore it. 
            builder: (ctx, product, _) {
            return IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                print("toggle favorite " + product.title);
                product.toggleFavoriteStatus();
              },
            );
          }),//
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              print("Add to cart : " + product.title);
            },
          ),
        ),
      ),
    );
  }
}