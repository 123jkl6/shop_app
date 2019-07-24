import "package:flutter/foundation.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:json_annotation/json_annotation.dart";
import 'package:shop_app/shared/url.dart';

part "product.g.dart";

@JsonSerializable()
class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      @required this.isFavorite});

  void toggleFavoriteStatus(String token,String userId) async {
    http.Response response = await http.put("${Url.favUrl}/$userId/$id.json?auth=$token",
        body: json.encode(!isFavorite));
    print("toggle favorite status.");
    print(response.statusCode);
    try {
      print(json.decode(response.body));
    } catch (error) {
      print(response.body);
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      isFavorite = !isFavorite;
      notifyListeners();
    }
  }

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
