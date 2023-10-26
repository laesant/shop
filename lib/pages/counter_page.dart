import 'package:flutter/material.dart';
import 'package:shop/providers/counter.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({
    super.key,
  });

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    final provider = CounterProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exemplo Contador"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(provider?.state.value.toString() ?? ""),
          IconButton(
              onPressed: () {
                setState(() {
                  provider?.state.inc();
                });
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                setState(() {
                  provider?.state.dec();
                });
              },
              icon: const Icon(Icons.remove))
        ],
      ),
    );
  }
}
