import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/models/order.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({super.key, required this.order});
  final Order order;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
                'R\$ ${widget.order.total.toStringAsFixed(2).replaceAll('.', ',')}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm', 'pt').format(widget.order.date)),
            trailing: IconButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more)),
          ),
          AnimatedContainer(
              height: _expanded ? (widget.order.products.length * 25) + 15 : 0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ListView(
                  children: widget.order.products
                      .map((product) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  product.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${product.quantity}x R\$ ${product.price}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ))
                      .toList()))
        ],
      ),
    );
  }
}
