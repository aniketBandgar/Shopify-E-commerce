import 'package:flutter/material.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_outlet_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friends'),
            // automaticallyImplyLeading: false,
          ),
          ListTile(
            contentPadding: EdgeInsets.all(10),
            leading: CircleAvatar(
              child: Icon(
                Icons.shop,
              ),
            ),
            trailing: Text(
              'Shop',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductOutletScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.all(10),
            leading: CircleAvatar(
              child: Icon(
                Icons.payment,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
            trailing: Text(
              'Orders',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.all(10),
            leading: CircleAvatar(
              child: Icon(Icons.edit),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
            trailing: Text(
              'Manage Products',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
