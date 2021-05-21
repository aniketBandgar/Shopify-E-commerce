import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widget/drawer.dart';
import '../widget/oreder_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/Order_Screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future _ordersFuture;

  Future _obtainOrderFuture() {
    return Provider.of<Order>(context, listen: false).fetchOrder();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              return Center(
                child: Text('an error occured'),
              );
            } else {
              return Consumer<Order>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemBuilder: (ctx, i) {
                    return OrderItemForOrderScreen(orderData.items[i]);
                  },
                  itemCount: orderData.items.length,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
