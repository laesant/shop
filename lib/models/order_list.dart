import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';
import 'package:shop/utils/constants.dart';

class OrderList with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  Future<void> loadOrders() async {
    _items.clear();
    var response = await http.get(Uri.parse("${Constants.orderBaseUrl}.json"));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((key, value) {
      _items.add(Order(
          id: key,
          total: value['total'],
          products: List<CartItem>.from(value['products']
              .map((cartItem) => CartItem(
                  id: cartItem['id'],
                  productId: cartItem['productId'],
                  name: cartItem['name'],
                  quantity: cartItem['quantity'],
                  price: cartItem["price"]))
              .toList()),
          date: DateTime.parse(value['date'])));
    });
    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    var response = await http.post(Uri.parse("${Constants.orderBaseUrl}.json"),
        body: jsonEncode({
          "total": cart.totalAmount,
          "date": date.toIso8601String(),
          "products": cart.items.values
              .map((cartItem) => {
                    "id": cartItem.id,
                    "productId": cartItem.productId,
                    "name": cartItem.name,
                    "quantity": cartItem.quantity,
                    "price": cartItem.price
                  })
              .toList(),
        }));

    final id = jsonDecode(response.body)['name'];
    _items.insert(
        0,
        Order(
          id: id,
          total: cart.totalAmount,
          products: cart.items.values.toList(),
          date: date,
        ));
    notifyListeners();
  }
}
