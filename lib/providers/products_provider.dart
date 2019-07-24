import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import 'package:shop_app/model/http_exception.dart';
import 'package:shop_app/shared/url.dart';
import "dart:convert";

import "../model/product.dart";

class Products with ChangeNotifier {
  final url = Url.storageUrl;
  List<Product> _items = [
    // Product(
    //   id: "1",
    //   title: "dummy prod",
    //   price: 12.99,
    //   description: "dummy desc",
    //   imageUrl:
    //       "https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg",
    //   isFavorite: false,
    // ),
  ];
  List<String> _favItems = [];

  var _showFavoritesOnly = false;
  final String token;
  final String userId;

  Products(_items, {this.token, this.userId});

  List<Product> get items {
    // if (_showFavoritesOnly){
    //   return _items.where((el)=>el.isFavorite).toList();
    // }
    return [..._items];
  }

  //filter fav
  List<Product> get getFavItems {
    return _items.where((el) => el.isFavorite).toList();
  } // Product(
  //   id: "1",
  //   title: "dummy prod",
  //   price: 12.99,
  //   description: "dummy desc",
  //   imageUrl:
  //       "https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg",
  //   isFavorite: false,
  // ),

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

  Future<void> fetchAndSetProducts() async {
    print(url);
    print(token);
    final http.Response resp =
        await http.get("${Url.favUrl}/$userId.json?auth=$token");

    print(resp.statusCode);
    final respBody = json.decode(resp.body) as Map<String, dynamic>;
    print(respBody);

    if (respBody == null) {
      return;
    }

    http.Response response = await http.get("$url.json?auth=$token");
    final responseBody = json.decode(response.body) as Map<String, dynamic>;
    final List<Product> loadedProducts = [];
    print(response.statusCode);
    print(responseBody);
    if (responseBody == null) {
      notifyListeners();
      return;
    }
    responseBody.forEach((prodId, prodData) {
      loadedProducts.add(
        Product(
          id: prodId,
          title: prodData["title"],
          description: prodData["description"],
          price: prodData["price"],
          isFavorite: respBody[prodId] != null ? respBody[prodId] : false,
          imageUrl: prodData["imageUrl"],
        ),
      );
    });
    _items = loadedProducts;
    notifyListeners();
  }

  Future<void> addProduct(product) async {
    http.Response response =
        await http.post("$url.json?auth=$token", body: jsonEncode(product));
    var responseBody = json.decode(response.body);
    print(responseBody);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final newProduct = Product(
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
        id: responseBody["name"],
      );
      _items.add(newProduct);
      print(_items.toString());
      return Future.value(null);
    }

    notifyListeners();
  }

  Future<void> updatedProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      await http.patch("$url/$id.json?auth=$token",
          body: jsonEncode(newProduct));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("Non-zero index detected : " + prodIndex.toString());
    }
  }

  Future<void> deleteProduct(String id) async {
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);

    http.Response response = await http.delete("$url/$id.json?auth=$token");
    print(response.statusCode);
    print(response.toString());
    if (response.statusCode != 200) {
      throw HttpException("Could not delete products. ");
    }
    //print(json.decode(response.body));
    _items.removeAt(existingProductIndex);
    notifyListeners();
  }
}
