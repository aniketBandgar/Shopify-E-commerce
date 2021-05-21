import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/Edit_Product_screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  bool _initvalue = true;
  Map initialValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isLoading = false;

  final _form = GlobalKey<FormState>();
  var _edittedProduct = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateFocus);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initvalue) {
      String productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _edittedProduct =
            Provider.of<ProdutProvider>(context).findById(productId);
        initialValues = {
          'title': _edittedProduct.title,
          'description': _edittedProduct.description,
          'price': _edittedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _edittedProduct.imageUrl;
      }
    }

    _initvalue = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateFocus);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateFocus() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }

      setState(() {});
    }
  }

  Future<void> _showDialogWidget() {
    return showDialog<Null>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('an error occured'),
            content: Text('something went wrong'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('okey'),
              ),
            ],
          );
        });
  }

  void saveForm(BuildContext ctx) async {
    setState(() {
      _isLoading = true;
    });
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    if (_edittedProduct.id != null) {
      try {
        await Provider.of<ProdutProvider>(context, listen: false)
            .updateProduuct(_edittedProduct.id, _edittedProduct);
      } catch (error) {
        await _showDialogWidget();
      }
    } else {
      try {
        await Provider.of<ProdutProvider>(context, listen: false)
            .addValue(_edittedProduct);
      } catch (error) {
        await _showDialogWidget();
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edit Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => saveForm(context),
          )
        ],
      ),
      body: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: initialValues['title'],
                        decoration: InputDecoration(
                          labelText: 'title',
                        ),
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _edittedProduct = Product(
                              id: _edittedProduct.id,
                              title: value,
                              description: _edittedProduct.description,
                              imageUrl: _edittedProduct.imageUrl,
                              price: _edittedProduct.price,
                              isFavourite: _edittedProduct.isFavourite);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please enter title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: initialValues['price'],
                        decoration: InputDecoration(
                          labelText: 'price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          _edittedProduct = Product(
                              id: _edittedProduct.id,
                              title: _edittedProduct.title,
                              description: _edittedProduct.description,
                              imageUrl: _edittedProduct.imageUrl,
                              price: double.parse(value),
                              isFavourite: _edittedProduct.isFavourite);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please enter price';
                          }
                          if (double.parse(value) <= 0) {
                            return 'please enter valid price';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: initialValues['description'],
                        decoration: InputDecoration(
                          labelText: 'description',
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) {
                          _edittedProduct = Product(
                              id: _edittedProduct.id,
                              title: _edittedProduct.title,
                              description: value,
                              imageUrl: _edittedProduct.imageUrl,
                              price: _edittedProduct.price,
                              isFavourite: _edittedProduct.isFavourite);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please enter description';
                          }
                          if (value.length <= 10) {
                            return 'please enter atleast 10 characters';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 10, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 2),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text(
                                    'Enter Url',
                                    textAlign: TextAlign.center,
                                  )
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Image Url',
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onSaved: (value) {
                                _edittedProduct = Product(
                                    id: _edittedProduct.id,
                                    title: _edittedProduct.title,
                                    description: _edittedProduct.description,
                                    imageUrl: value,
                                    price: _edittedProduct.price,
                                    isFavourite: _edittedProduct.isFavourite);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please enter image Url';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'please enter valid url';
                                }
                                if (!value.endsWith('.jpg') &&
                                    !value.endsWith('.png') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'please enter valid url';
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
