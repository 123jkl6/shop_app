import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../model/order.dart" show Orders;

import "../widgets/order_item.dart";
import "../widgets/app_drawer.dart";

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
      } catch (error) {
        print(error);
        showDialog(context: context,builder: (ctx){
                  return AlertDialog(
                    title: Text("Fetching orders Failed"),
                    content: Text("Failed to fetch orders, please try again later"),
                    actions: <Widget>[
                      RaisedButton(child:Text("OK"),onPressed: (){
                        Navigator.of(context).pop();
                      },),
                    ],
                  );
                });
      }
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Your Orders")),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orders.orders.length,
              itemBuilder: (ctx, i) => OrderItem(loadedOrder: orders.orders[i]),
            ),
      drawer: AppDrawer(),
    );
  }
}
