import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/models/order.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({super.key, required this.order});
  final Order order;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title:
            Text('R\$ ${order.total.toStringAsFixed(2).replaceAll('.', ',')}'),
        subtitle: Text(DateFormat('dd/MM/yyyy hh:mm', 'pt').format(order.date)),
        trailing:
            IconButton(onPressed: () {}, icon: const Icon(Icons.expand_more)),
      ),
    );
  }
}
