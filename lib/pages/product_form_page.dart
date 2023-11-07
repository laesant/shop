import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
  bool _isLoading = false;
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
  void didChangeDependencies() {
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
    super.didChangeDependencies();
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

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithExtension = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endsWithExtension;
  }

  void _submitForm() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    try {
      await Provider.of<ProductList>(context, listen: false)
          .saveProduct(_formData);
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Ocorreu um erro"),
                  content: const Text('Ocorreu um erro para salvar o produto.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Okay"))
                  ],
                ));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Formulário de Produto"),
          actions: [
            IconButton(onPressed: _submitForm, icon: const Icon(Icons.save))
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(15),
                  children: [
                    TextFormField(
                      initialValue: _formData['name'],
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: "Nome"),
                      onFieldSubmitted: (_) => _priceFocus.requestFocus(),
                      onSaved: (name) => _formData['name'] = name ?? "",
                      validator: (value) {
                        final String name = value ?? "";
                        if (name.trim().isEmpty) {
                          return 'Nome é obriatório';
                        }
                        if (name.trim().length < 3) {
                          return 'Nome precisa no mínimo de 3 letras.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price']?.toString(),
                      focusNode: _priceFocus,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: "Preço"),
                      onFieldSubmitted: (_) => _descriptionFocus.requestFocus(),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onSaved: (price) =>
                          _formData['price'] = double.parse(price ?? "0.0"),
                      validator: (value) {
                        final double price =
                            double.tryParse(value ?? '-1') ?? -1;

                        if (price <= 0) {
                          return "Informe um preço válido.";
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description'],
                      focusNode: _descriptionFocus,
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(labelText: "Descrição"),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSaved: (description) =>
                          _formData['description'] = description ?? "",
                      validator: (value) {
                        final String description = value ?? "";
                        if (description.trim().isEmpty) {
                          return 'Descrição é obriatório';
                        }
                        if (description.trim().length < 10) {
                          return 'Descrição precisa no mínimo de 10 letras.';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            focusNode: _imageUrlFocus,
                            decoration: const InputDecoration(
                                labelText: "Url da Imagem"),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onChanged: (_) => updateImage(),
                            onFieldSubmitted: (_) => _submitForm(),
                            onSaved: (imageUrl) =>
                                _formData['imageUrl'] = imageUrl ?? "",
                            validator: (value) {
                              final String imageUrl = value ?? '';

                              if (!isValidImageUrl(imageUrl)) {
                                return "Informe uma Url válida!";
                              }

                              return null;
                            },
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
                                      image: NetworkImage(
                                          _imageUrlController.text))
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
