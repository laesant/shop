import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/utils/app_routes.dart';

enum FilterOptions {
  favorite,
  all;
}

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({super.key});

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minha Loja"),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.cart),
              icon: Badge(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  label: Consumer<Cart>(
                    builder: (context, cart, child) => Text(
                      cart.itemsCount.toString(),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                  child: const Icon(Icons.shopping_cart))),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: PopupMenuButton(
                tooltip: "Mostrar menu",
                onSelected: (FilterOptions selectedValue) {
                  setState(() {
                    if (selectedValue == FilterOptions.favorite) {
                      _showFavoriteOnly = true;
                    } else {
                      _showFavoriteOnly = false;
                    }
                  });
                },
                itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: FilterOptions.favorite,
                        child: Text("Somente Favoritos"),
                      ),
                      const PopupMenuItem(
                        value: FilterOptions.all,
                        child: Text("Todos"),
                      ),
                    ]),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductGrid(showFavoriteOnly: _showFavoriteOnly),
    );
  }
}
