import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/products_provider.dart";

import "../screens/edit_product_screen.dart";

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProduct.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () async {
                try {
                  await Provider.of<Products>(context).deleteProduct(id);
                } catch (error) {
                  print(error);
                  //use scaffoled variable from before instead of fetching it
                  //because updating ui at this point changes context
                  // this method is async.
                  scaffold.showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 3),
                      content: Text(
                        "Deleting failed!",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
