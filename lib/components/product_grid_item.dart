import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
              builder: (context, product, _) => IconButton(
                  color: Colors.redAccent.shade100,
                  onPressed: () => product.toggleFavorite(
                      auth.token ?? '', auth.userId ?? ''),
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border))),
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              onPressed: () {
                cart.addItem(product);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    action: SnackBarAction(
                        label: "Desfazer",
                        onPressed: () => cart.removeSingleItem(product.id)),
                    duration: const Duration(seconds: 2),
                    content: const Text("Produto adicionado com sucesso!")));
              },
              icon: const Icon(Icons.shopping_cart)),
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(AppRoutes.productDetail, arguments: product),

          child: FadeInImage(
              fit: BoxFit.cover,
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(
                product.imageUrl,
              )),
          // child: Image.network(
          //   product.imageUrl,
          //   fit: BoxFit.cover,
          // ),
        ),
      ),
    );
  }
}
