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
      setState(() {});
    }
  }

  void _saveForm() {
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
                          decoration: InputDecoration(labelText: 'Image URL'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          onFieldSubmitted: (_) {
                            _saveForm();
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
