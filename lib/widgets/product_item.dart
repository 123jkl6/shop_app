import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../model/product.dart";
import "../model/cart.dart";

import "../providers/auth.dart";

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    //cart only used to dispatch actions, not update UI
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    //using Provider results in build method being called;
    //using Consumer only rebuilds affected widget branch
    //works well in a grid.
    print("product item build ID : " + product.id);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage("assets/images/product-placeholder.png"),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
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
                product.toggleFavoriteStatus(auth.token, auth.userId);
              },
            );
          }), //
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              print("Add to cart : " + product.title);
              cart.addItem(
                  title: product.title,
                  price: product.price,
                  productId: product.id);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("Added item to cart. "),
                  duration: Duration(
                    seconds: 3,
                  ),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
