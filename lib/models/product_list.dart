import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/constants.dart';

class ProductList with ChangeNotifier {
  final String _token;
  final List<Product> _items;

  ProductList(this._token, this._items);

  List<Product> get items => [..._items];

  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();
  int get itemsCount => _items.length;

  Future<void> loadProducts() async {
    _items.clear();
    var response = await http
        .get(Uri.parse("${Constants.productBaseUrl}.json?auth=$_token"));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((key, value) {
      _items.add(Product(
        id: key,
        name: value["name"],
        description: value["description"],
        price: value["price"],
        imageUrl: value["imageUrl"],
      ));
    });
    notifyListeners();
  }

  Future<void> _addProduct(Product product) async {
    var response = await http.post(
        Uri.parse("${Constants.productBaseUrl}.json?auth=$_token"),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        }));

    final id = jsonDecode(response.body)['name'];

    _items.add(Product(
      id: id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> _updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      await http.patch(
          Uri.parse(
              "${Constants.productBaseUrl}/${product.id}.json?auth=$_token"),
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

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _items.remove(product);
      notifyListeners();

      var response = await http.delete(Uri.parse(
          "${Constants.productBaseUrl}/${product.id}.json?auth=$_token"));

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException(
            msg: 'Não foi possivel excluir o produto.',
            statusCode: response.statusCode);
      }
    }
  }
}
