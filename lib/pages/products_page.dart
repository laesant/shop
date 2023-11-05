import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/models/product_list.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text("Gerenciar Produtos")),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: products.itemsCount,
          itemBuilder: (contex, index) => Text(products.items[index].name)),
    );
  }
}
