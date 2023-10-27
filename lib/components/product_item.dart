import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
              builder: (context, product, _) => IconButton(
                  color: Theme.of(context).colorScheme.tertiary,
                  onPressed: product.toggleFavorite,
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border))),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart)),
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(AppRoutes.productDetail, arguments: product),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
