import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order.dart';

class OrderList with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  void addOrder(Cart cart) {
    _items.insert(
        0,
        Order(
            id: Random().nextDouble().toString(),
            total: total,
            products: products,
            date: date));
  }
}
