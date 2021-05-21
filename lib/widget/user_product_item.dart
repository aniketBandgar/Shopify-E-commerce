import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import '../providers/product_provider.dart';

class UserProductItemForManeging extends StatelessWidget {
  final String id;
  final String title;
  final String imageurl;

  UserProductItemForManeging({
    @required this.id,
    @required this.title,
    @required this.imageurl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageurl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () async {
                try {
                  await Provider.of<ProdutProvider>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('deletion failed!')));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
