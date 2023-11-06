import 'package:flutter/material.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  late final FocusNode _priceFocus;
  late final FocusNode _descriptionFocus;
  @override
  void initState() {
    _priceFocus = FocusNode();
    _descriptionFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _priceFocus.dispose();
    _descriptionFocus.dispose();
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
              onFieldSubmitted: (_) => _descriptionFocus.requestFocus(),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextFormField(
              focusNode: _descriptionFocus,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: "Descrição"),
              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
          ],
        )));
  }
}
