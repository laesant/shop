import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';
import 'package:shop/utils/constants.dart';

class OrderList with ChangeNotifier {
  final String _token;
  List<Order> _items;

  OrderList(this._token, this._items);

  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  Future<void> loadOrders() async {
    List<Order> items = [];
    var response = await http
        .get(Uri.parse("${Constants.orderBaseUrl}.json?auth=$_token"));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((key, value) {
      items.add(Order(
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
    _items = items.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    var response = await http.post(
        Uri.parse("${Constants.orderBaseUrl}.json?auth=$_token"),
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
