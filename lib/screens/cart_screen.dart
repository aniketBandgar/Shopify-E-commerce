import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widget/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routName = '/Cart_Screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Our Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.total.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ButtonForOrderNow(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, i) {
                return CartItemForCartScreen(
                  productId: cart.items.keys.toList()[i],
                  id: cart.items.values.toList()[i].id,
                  price: cart.items.values.toList()[i].price,
                  quantity: cart.items.values.toList()[i].quantity,
                  title: cart.items.values.toList()[i].title,
                );
              },
              itemCount: cart.items.length,
            ),
          )
        ],
      ),
    );
  }
}

class ButtonForOrderNow extends StatefulWidget {
  const ButtonForOrderNow({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _ButtonForOrderNowState createState() => _ButtonForOrderNowState();
}

class _ButtonForOrderNowState extends State<ButtonForOrderNow> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).canvasColor,
      ),
      onPressed: (widget.cart.total <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await Provider.of<Order>(context, listen: false).addOrder(
                    widget.cart.total, widget.cart.items.values.toList());
                widget.cart.clearData();
              } catch (error) {
                return showDialog<Null>(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text('an error occured'),
                        content: Text('something went wrong'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text('okey'),
                          ),
                        ],
                      );
                    });
              }
              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Text(
              'order now',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
              ),
            ),
    );
  }
}
