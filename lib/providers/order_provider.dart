import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final List<CartItem> products;
  final DateTime dateTime;
  final double totalAmount;

  OrderItem({
    @required this.id,
    @required this.products,
    @required this.dateTime,
    @required this.totalAmount,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _items = [];

  List<OrderItem> get items {
    return [..._items];
  }

  Future<void> fetchOrder() async {
    final url = Uri.parse(
        'https://shop-app-6311a-default-rtdb.firebaseio.com/Orders.json');
    final response = await http.get(url);
    print(jsonDecode(response.body));
    List<OrderItem> loadedOrders = [];
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderdata) {
      loadedOrders.add(OrderItem(
          id: orderId,
          products: (orderdata['products'] as List<dynamic>)
              .map((e) => CartItem(
                    id: e['id'],
                    price: e['price'],
                    quantity: e['quantity'],
                    title: e['title'],
                  ))
              .toList(),
          dateTime: DateTime.parse(orderdata['datetime']),
          totalAmount: orderdata['total']));
    });
    _items = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(double total, List<CartItem> cartProducts) async {
    final url = Uri.parse(
        'https://shop-app-6311a-default-rtdb.firebaseio.com/Orders.json');
    DateTime dateTime = DateTime.now();
    try {
      final response = await http.post(url,
          body: jsonEncode({
            'datetime': dateTime.toIso8601String(),
            'total': total,
            'products': cartProducts
                .map((e) => {
                      'id': e.id,
                      'price': e.price,
                      'title': e.title,
                      'quantity': e.quantity
                    })
                .toList(),
          }));

      _items.insert(
          0,
          OrderItem(
              id: jsonDecode(response.body)['name'],
              products: cartProducts,
              dateTime: dateTime,
              totalAmount: total));
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }
}
