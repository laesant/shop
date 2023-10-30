import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrinho"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(25),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Chip(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      label: Text(
                        "R\$${cart.totalAmount}",
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headlineMedium
                                ?.color),
                      )),
                  const Spacer(),
                  TextButton(
                      style: TextButton.styleFrom(
                          textStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary)),
                      onPressed: () {},
                      child: const Text("COMPRAR"))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
