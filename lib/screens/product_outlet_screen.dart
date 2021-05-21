import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widget/drawer.dart';
import '../widget/product_grid.dart';
import '../widget/badge.dart';

enum FilterOption {
  All,
  Favourite,
}

class ProductOutletScreen extends StatefulWidget {
  static const String routeName = '/productOutlet ';
  @override
  _ProductOutletScreenState createState() => _ProductOutletScreenState();
}

class _ProductOutletScreenState extends State<ProductOutletScreen> {
  bool showFavs = false;

  void onSelected(value) {
    if (value == FilterOption.All) {
      setState(() {
        showFavs = false;
      });
    } else {
      setState(() {
        showFavs = true;
      });
    }
  }

  Future _products;

  Future _obtainFutureProduct() {
    return Provider.of<ProdutProvider>(context, listen: false)
        .fetchDataFromServer();
  }

  @override
  void initState() {
    _products = _obtainFutureProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('all Product'),
                value: FilterOption.All,
              ),
              PopupMenuItem(
                child: Text('fav Product'),
                value: FilterOption.Favourite,
              ),
            ],
            onSelected: onSelected,
          ),
          Consumer<Cart>(
            builder: (ctx, cart, ch) {
              return Badge(
                child: ch,
                value: cart.itemCount.toString(),
              );
            },
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routName);
                }),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _products,
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
              return ProductGrid(showFavs);
            }
          }
        },
      ),
    );
  }
}
