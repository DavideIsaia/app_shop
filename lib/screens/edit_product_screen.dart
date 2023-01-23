import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: "",
    price: 0,
    description: "",
    imageUrl: "",
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    // serve per non perdere l'anteprima dell'img quando si sposta il focus nei form
    super.initState();
  }

  @override
  // aggiungere sempre i dispose per liberare spazio in memoria quando si usano i form
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          !_imageUrlController.text.startsWith('http') ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifica prodotto'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nome'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(
                        _priceFocusNode); //premendo avanti passa il focus dal primo input al secondo (perchè l'input seguente ha la proprietà focusNode)
                  },
                  validator: (userInputValue) {
                    if (userInputValue.isEmpty) {
                      return "Inserisci un nome per il prodotto";
                    }
                    return null;
                  },
                  onSaved: ((userInputValue) {
                    _editedProduct = Product(
                      id: null,
                      title: userInputValue,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                    );
                  }),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Prezzo'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (userInputValue) {
                    if (userInputValue.isEmpty) {
                      return "Inserisci un prezzo per il prodotto";
                    }
                    if (double.tryParse(userInputValue) == null) {
                      return "Inserisci un numero valido";
                    }
                    if (double.parse(userInputValue) <= 0) {
                      return "Inserisci un numero maggiore di zero";
                    }
                    return null;
                  },
                  onSaved: ((userInputValue) {
                    _editedProduct = Product(
                      id: null,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(userInputValue),
                      imageUrl: _editedProduct.imageUrl,
                    );
                  }),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Descrizione'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  validator: (userInputValue) {
                    if (userInputValue.isEmpty) {
                      return "Inserisci una descrizione per il prodotto";
                    }
                    if (userInputValue.length < 10) {
                      return "La descrizione deve essere di almeno 10 caratteri";
                    }
                    return null;
                  },
                  onSaved: ((userInputValue) {
                    _editedProduct = Product(
                      id: null,
                      title: _editedProduct.title,
                      description: userInputValue,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                    );
                  }),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      )),
                      child: _imageUrlController.text.isEmpty
                          ? Text("Inserisci l'url di un'immagine")
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                          decoration:
                              InputDecoration(labelText: 'URL immagine'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          validator: (userInputValue) {
                            if (userInputValue.isEmpty) {
                              return "Inserisci un'immagine per il prodotto";
                            }
                            if (!userInputValue.startsWith('http')) {
                              return "Inserisci un URL valido";
                            }
                            if (!userInputValue.endsWith('.png') &&
                                !userInputValue.endsWith('.jpg')) {
                              return "Inserisci un URL immagine valido";
                            }
                            return null;
                          },
                          onSaved: ((userInputValue) {
                            _editedProduct = Product(
                              id: null,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: userInputValue,
                            );
                          }),
                          onEditingComplete: () {
                            setState(() {});
                          }),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
