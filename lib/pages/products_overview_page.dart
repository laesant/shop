import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/models/product_list.dart';

enum FilterOptions {
  favorite,
  all;
}

class ProductsOverviewPage extends StatelessWidget {
  const ProductsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minha Loja"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: PopupMenuButton(
                tooltip: "Mostrar menu",
                onSelected: (FilterOptions selectedValue) {
                  if (selectedValue == FilterOptions.favorite) {
                    provider.showFavoriteOnly();
                  } else {
                    provider.showAll();
                  }
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
      body: const ProductGrid(),
    );
  }
}
