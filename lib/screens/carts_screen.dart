import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:shop_app/model/cart.dart' show Cart;
import "../model/order.dart";
import "../widgets/cart_item.dart";

class OrderButton extends StatefulWidget {
  final Cart cart;

  OrderButton({this.cart});

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text("ORDER NOW"),
      onPressed: widget.cart.totalAmount <= 0 || _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              print("Ordering now.");
              try {
              await Provider.of<Orders>(
                context,
                listen: false,
              ).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              //clear the cart, because items are ordered.
              widget.cart.clear();
              } catch (error){
                print(error);
                showDialog(context: context,builder: (ctx){
                  return AlertDialog(
                    title: Text("Order Failed"),
                    content: Text("Failed to send order, please try again later"),
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
              
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}

class CartsScreen extends StatelessWidget {
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15.0),
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Total",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Spacer(),
                    Chip(
                      label: Text("\$${cart.totalAmount.toStringAsFixed(2)}",
                          style: TextStyle(
                            color:
                                Theme.of(context).primaryTextTheme.title.color,
                          )),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    OrderButton(
                      cart: cart,
                    ),
                  ],
                )),
          ),
          SizedBox(height: 10),
          //Expanded widget to accomodate ListView
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) {
                //naming conflict fixed above with show keyword.
                return CartItem(
                  id: cart.items.values.toList()[i].id,
                  productId: cart.items.keys.toList()[i],
                  title: cart.items.values.toList()[i].title,
                  price: cart.items.values.toList()[i].price,
                  quantity: cart.items.values.toList()[i].quantity,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
