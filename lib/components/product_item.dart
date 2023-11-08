import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () => Navigator.of(context)
                    .pushNamed(AppRoutes.productForm, arguments: product),
                icon: Icon(
                  Icons.edit,
                  color: Colors.grey.shade600,
                )),
            IconButton(
                onPressed: () {
                  showDialog<bool?>(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text("Excluir Produto"),
                            content: const Text("Tem certeza?"),
                            actions: [
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Não")),
                              TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Sim"))
                            ],
                          )).then((value) {
                    if (value ?? false) {
                      Provider.of<ProductList>(context, listen: false)
                          .removeProduct(product);
                    }
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
          ],
        ),
      ),
    );
  }
}