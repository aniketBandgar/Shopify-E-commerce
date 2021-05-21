import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavourite;
  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavourite = false,
  });

  Future<void> toggledFavourite(String id) async {
    final url = Uri.parse(
        'https://shop-app-6311a-default-rtdb.firebaseio.com/Product/$id.json');
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      final response = await http.patch(url,
          body: jsonEncode({
            'isFav': isFavourite,
          }));
      if (response.statusCode >= 400) {
        isFavourite = !isFavourite;
        notifyListeners();
      }
    } catch (error) {
      isFavourite = !isFavourite;
      notifyListeners();
    }
  }
}
