import "package:flutter/material.dart";
import "dart:math";
import 'package:intl/intl.dart';
import "package:provider/provider.dart";
import "../model/order.dart" as order;

class OrderItem extends StatefulWidget {
  final order.OrderItem loadedOrder;

  OrderItem({@required this.loadedOrder});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false; //initialize to false
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration:Duration(milliseconds: 300),
      height:_expanded?min(
                  widget.loadedOrder.products.length * 20.0 + 110,
                  200.0,
                ) : 95,
          child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text("\$${widget.loadedOrder.amount}"),
              subtitle: Text(
                DateFormat("dd-MM-yyyy hh:mm")
                    .format(widget.loadedOrder.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            //if statement in list (in-list if statement, available from flutter 2.2.2)
            //if (_expanded)
              AnimatedContainer(
                duration:Duration(milliseconds:300),
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 4,
                ),
                height: _expanded?  min(
                  widget.loadedOrder.products.length * 20.0 + 10,
                  180.0,
                ):0,
                child: ListView(
                    children: widget.loadedOrder.products
                        .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  prod.title,
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${prod.quantity}x \$${prod.price}",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ))
                        .toList()),
              )
          ],
        ),
      ),
    );
  }
}
