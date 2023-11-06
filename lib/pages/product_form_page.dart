import 'package:flutter/material.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  late final FocusNode _priceFocus;
  @override
  void initState() {
    _priceFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _priceFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Formulário de Produto"),
        ),
        body: Form(
            child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            TextFormField(
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: "Nome"),
              onFieldSubmitted: (_) => _priceFocus.requestFocus(),
            ),
            TextFormField(
              focusNode: _priceFocus,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: "Preço"),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            )
          ],
        )));
  }
}
