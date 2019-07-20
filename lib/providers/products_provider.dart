import "package:flutter/material.dart";

import "../model/product.dart";

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: "1",
      title: "dummy prod",
      price: 12.99,
      description: "dummy desc",
      imageUrl:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg",
      isFavorite: false,
    ),
  ];

  var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly){
    //   return _items.where((el)=>el.isFavorite).toList();
    // }
    return [..._items];
  }

  //filter fav
  List<Product> get getFavItems {
    return _items.where((el) => el.isFavorite).toList();
  }

  void showFavoriteOnly() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  }

  Product findProductById(String id) {
    return _items.firstWhere((el) => id == el.id);
  }

  void addProduct(product) {
    final newProduct = Product(
      title: product.title,
      price: product.price,
      description: product.description,
      imageUrl: product.imageUrl,
      isFavorite: product.isFavorite,
      id: DateTime.now().toString(),
    );
    _items.add(newProduct);
    notifyListeners();
  }

  void updatedProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("Non-zero index detected : " + prodIndex.toString());
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod)=>prod.id==id);
    notifyListeners();
  }
}
