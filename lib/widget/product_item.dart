import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // final double price;

  // ProductItem(
  //     {@required this.id,
  //     @required this.title,
  //     @required this.imageUrl,
  //     @required this.price});
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routename,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87.withOpacity(0.9),
          leading: Consumer<Product>(
            builder: (ctx, product, _) {
              return IconButton(
                icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () async {
                  try {
                    await product.toggledFavourite(product.id);
                  } catch (error) {
                    await showDialog<Null>(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text('something went wrong'),
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
                },
              );
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to the cart',
                  ),
                  duration: Duration(
                    seconds: 2,
                  ),
                  action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeCartItemByUndo(product.id);
                      }),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
