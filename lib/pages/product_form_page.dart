import 'package:flutter/material.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  late final FocusNode _priceFocus;
  late final FocusNode _descriptionFocus;
  late final FocusNode _imageUrlFocus;
  late final TextEditingController _imageUrlController;
  @override
  void initState() {
    _priceFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _imageUrlFocus = FocusNode();
    _imageUrlController = TextEditingController();
    _imageUrlFocus.addListener(updateImage);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocus.removeListener(updateImage);
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void updateImage() => setState(() {});

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
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(labelText: "Descrição"),
              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    focusNode: _imageUrlFocus,
                    decoration:
                        const InputDecoration(labelText: "Url da Imagem"),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    controller: _imageUrlController,
                    onChanged: (_) => updateImage(),
                  ),
                ),
                Container(
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 10, left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      image: _imageUrlController.text.isNotEmpty
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(_imageUrlController.text))
                          : null),
                  child: _imageUrlController.text.isEmpty
                      ? const Text('Informe a Url')
                      : null,
                )
              ],
            ),
          ],
        )));
  }
}
