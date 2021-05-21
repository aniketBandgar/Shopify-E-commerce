import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/widget/drawer.dart';
import 'package:shop_app/widget/user_product_item.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/User_Product_Screen';

  Future<void> _onrefresh(BuildContext ctx) async {
    await Provider.of<ProdutProvider>(ctx, listen: false).fetchDataFromServer();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProdutProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _onrefresh(context),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: ListView.builder(
            itemBuilder: (ctx, i) => Column(
              children: [
                UserProductItemForManeging(
                  id: productData.items[i].id,
                  title: productData.items[i].title,
                  imageurl: productData.items[i].imageUrl,
                ),
                Divider(),
              ],
            ),
            itemCount: productData.items.length,
          ),
        ),
      ),
    );
  }
}
