import 'dart:math';
import '../providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/order_provider.dart';

class OrderItemForOrderScreen extends StatefulWidget {
  final OrderItem order;
  OrderItemForOrderScreen(this.order);

  @override
  _OrderItemForOrderScreenState createState() =>
      _OrderItemForOrderScreenState();
}

class _OrderItemForOrderScreenState extends State<OrderItemForOrderScreen> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.all(10),
          elevation: 15,
          child: ListTile(
            title: Text(
              '\$${widget.order.totalAmount}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              DateFormat('dd/MM/yy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon((_expanded) ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
        ),
        if (_expanded)
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(15),
            height: min(widget.order.products.length * 40.0 + 20, 180),
            child: ListView(
              children: widget.order.products
                  .map((e) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.title,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${e.price} x${e.quantity}',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          )
                        ],
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}
