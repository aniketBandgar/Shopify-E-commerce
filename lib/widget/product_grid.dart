import 'package:flutter/material.dart';
import './product_item.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showsfav;
  ProductGrid(this.showsfav);

  @override
  Widget build(BuildContext context) {
    final productObject = Provider.of<ProdutProvider>(context);
    final productList =
        showsfav ? productObject.favProduct : productObject.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: productList[index],
          child: ProductItem(
              // id: productList[index].id,
              // title: productList[index].title,
              // imageUrl: productList[index].imageUrl,
              // price: productList[index].price,
              ),
        );
      },
      itemCount: productList.length,
    );
  }
}
