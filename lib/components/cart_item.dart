import 'package:flutter/material.dart';
import 'package:shop/models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({super.key, required this.cartItem});

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Padding(
              padding: const EdgeInsets.all(5),
              child: FittedBox(
                child: Text(cartItem.price.toString()),
              )),
        ),
        title: Text(cartItem.name),
        subtitle: Text(
            "Total: R\$ ${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}"),
        trailing: Text("${cartItem.quantity}x"),
      ),
    );
  }
}
