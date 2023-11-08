import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = [];
  final String _baseUrl =
      'https://shop-ba83e-default-rtdb.firebaseio.com/products';

  List<Product> get items => [..._items];

  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();
  int get itemsCount => _items.length;

  Future<void> loadProducts() async {
    _items.clear();
    var response = await http.get(Uri.parse("$_baseUrl.json"));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((key, value) {
      _items.add(Product(
        id: key,
        name: value["name"],
        description: value["description"],
        price: value["price"],
        imageUrl: value["imageUrl"],
        isFavorite: value["isFavorite"],
      ));
    });
    notifyListeners();
  }

  Future<void> _addProduct(Product product) async {
    var response = await http.post(Uri.parse("$_baseUrl.json"),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        }));

    final id = jsonDecode(response.body)['name'];

    _items.add(Product(
      id: id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      isFavorite: product.isFavorite,
    ));
    notifyListeners();
  }

  Future<void> _updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      await http.patch(Uri.parse("$_baseUrl/${product.id}.json"),
          body: jsonEncode({
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          }));
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> saveProduct(Map<String, dynamic> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] : Random().nextDouble().toString(),
      name: data['name'],
      description: data['description'],
      price: data['price'],
      imageUrl: data['imageUrl'],
    );

    if (hasId) {
      return _updateProduct(product);
    } else {
      return _addProduct(product);
    }
  }

  void removeProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();
    }
  }
}
