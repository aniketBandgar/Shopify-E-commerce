import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final double price;
  final String title;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items == null ? 0 : _items.length;
  }

  void addItem(String id, double price, String title) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (value) => CartItem(
            id: value.id,
            price: value.price,
            quantity: value.quantity + 1,
            title: value.title),
      );
      notifyListeners();
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
            id: DateTime.now().toString(),
            price: price,
            quantity: 1,
            title: title),
      );
      notifyListeners();
    }
  }

  double get total {
    double total = 0;
    _items.forEach((key, value) {
      total = total + (value.price * value.quantity);
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearData() {
    _items = {};
    notifyListeners();
  }

  void removeCartItemByUndo(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (value) => CartItem(
          id: value.id,
          price: value.price,
          quantity: value.quantity - 1,
          title: value.title,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
