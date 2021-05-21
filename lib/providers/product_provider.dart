import 'dart:convert';

import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import '../models/httpException.dart';

class ProdutProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  String _authToken;

  ProdutProvider(this._authToken, this._items);

  Future<void> fetchDataFromServer() async {
    final url = Uri.parse(
        'https://shop-app-6311a-default-rtdb.firebaseio.com/Product.json?auth=$_authToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> _loadedData = [];
      extractedData.forEach((prodId, prodData) {
        _loadedData.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            isFavourite: prodData['isFav'],
          ),
        );
      });
      _items = _loadedData;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favProduct {
    return _items.where((element) => element.isFavourite).toList();
  }

  Future<void> addValue(Product product) async {
    final url = Uri.parse(
        'https://shop-app-6311a-default-rtdb.firebaseio.com/Product.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFav': product.isFavourite
          }));
      _items.add(Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      ));
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }

  Product findById(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://shop-app-6311a-default-rtdb.firebaseio.com/Product/$id.json');
    final exixtingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[exixtingProductIndex];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(exixtingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('error occured');
    }
    existingProduct = null;
  }

  Future<void> updateProduuct(String id, Product newProduct) async {
    final url = Uri.parse(
        'https://shop-app-6311a-default-rtdb.firebaseio.com/Product/$id.json');
    try {
      await http.patch(url,
          body: jsonEncode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl
          }));
    } catch (error) {
      throw error;
    }

    final index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      _items[index] = newProduct;
      notifyListeners();
    }
  }
}
