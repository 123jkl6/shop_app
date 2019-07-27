import "dart:convert";
import 'package:flutter/cupertino.dart';
import "package:http/http.dart" as http;
import 'package:shop_app/shared/url.dart';

import "./cart.dart";

class OrderItem with ChangeNotifier {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final String token;
  List<OrderItem> _orders = [];
  final String userId;

  Orders(_orders, {this.token,this.userId});

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    final http.Response response = await http.post("${Url.ordersUrl}$userId.json?auth=$token",
        body: json.encode({
          "amount": total,
          "dateTime": timestamp.toIso8601String(),
          "products": cartProducts
              .map((cp) => {
                    "id": cp.id,
                    "title": cp.title,
                    "quanity": cp.quantity,
                    "price": cp.price,
                  })
              .toList(),
        }));

    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)["name"],
          amount: total,
          dateTime: DateTime.now(),
          products: cartProducts,
        ));
  }

  Future<void> fetchAndSetOrders() async {
    final http.Response response = await http.get("${Url.ordersUrl}$userId.json?auth=$token");
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(response.statusCode);
    print(response.body);
    if (responseData == null) {
      return;
    }
    final List<OrderItem> orders = [];
    responseData.forEach((orderId, order) {
      orders.add(OrderItem(
        id: orderId,
        amount: order["amount"],
        products: (order["products"] as List<dynamic>)
            .map(
              (item) => CartItem(
                id: item["id"],
                title: item["title"],
                quantity: item["quantity"],
                price: item["price"],
              ),
            )
            .toList(),
        dateTime: DateTime.parse(order["dateTime"]),
      ));
    });
    _orders = orders;
    notifyListeners();
  }
}
