import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../model/order.dart" show Orders;

import "../widgets/order_item.dart";
import "../widgets/app_drawer.dart";

//converted back to stateless widget because of FutureBuilder
class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

//class _OrdersScreenState extends State<OrdersScreen> {
  // var _isLoading = false;
  // @override
  // void initState() {
  //   // Future.delayed(Duration.zero).then((_) async {
  //   //   setState(() {
  //   //     _isLoading = true;
  //   //   });
  //   //   try {
  //   //     await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //   //   } catch (error) {
  //   //     print(error);
  //   //     showDialog(context: context,builder: (ctx){
  //   //               return AlertDialog(
  //   //                 title: Text("Fetching orders Failed"),
  //   //                 content: Text("Failed to fetch orders, please try again later"),
  //   //                 actions: <Widget>[
  //   //                   RaisedButton(child:Text("OK"),onPressed: (){
  //   //                     Navigator.of(context).pop();
  //   //                   },),
  //   //                 ],
  //   //               );
  //   //             });
  //   //   }
  //   //   setState(() {
  //   //     _isLoading = false;
  //   //   });
  //   // });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    print("Building orders_screen to check how many times build method runs.");
    //removed for compatibility with future builder to avoid infinite loop.
    //final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Your Orders")),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              print(dataSnapshot.error);
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text("Fetching orders Failed"),
                      content: Text(
                          "Failed to fetch orders, please try again later"),
                      actions: <Widget>[
                        RaisedButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });

              return Text("Failed to fetch orders at this time. ");
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) =>
                      OrderItem(loadedOrder: orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
