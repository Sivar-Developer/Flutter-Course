import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/models/location_data.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:flutter_course/widgets/form_inputs/image.dart';
import 'package:flutter_course/widgets/form_inputs/location.dart';
import 'package:flutter_course/widgets/helpers/ensure_visible.dart';
import 'package:flutter_course/widgets/ui_elements/adaptive_progress_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': null,
    'location': null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _priceTextController = TextEditingController();

  Widget _buildTitleTextField(Product product) {
    if(product == null && _titleTextController.text.trim() == '') {
      _titleTextController.text = '';
    } else if (product != null && _titleTextController.text.trim() == '') {
      _titleTextController.text = product.title;
    } else if (_titleTextController.text.trim() != '') {
      _titleTextController.text = _titleTextController.text;
    } else {
      _titleTextController.text = '';
    }
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Product Title'),
        controller: _titleTextController,
        validator: (String value) {
          if (value.isEmpty || value.length < 5) {
            return 'Title is required and should be +5 characters long.';
          }
          return null;
        },
        onSaved: (String value) {
          _formData['title'] = value;
        },
      ),
    );
  }

  Widget _buildDescriptionTextField(Product product) {
     if(product == null && _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = '';
    } else if (product != null && _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = product.description;
    }
    return EnsureVisibleWhenFocused(
        focusNode: _descriptionFocusNode,
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Product Description'),
          maxLines: 4,
          controller: _descriptionTextController,
          validator: (String value) {
            if (value.isEmpty || value.length < 5) {
              return 'Description is required and should be +5 characters long.';
            }
            return null;
          },
          onSaved: (String value) {
            _formData['description'] = value;
          },
        ));
  }

  Widget _buildPriceTextField(Product product) {
    if(product == null && _priceTextController.text.trim() == '') {
      _priceTextController.text = '';
    } else if (product != null && _priceTextController.text.trim() == '') {
      _priceTextController.text = product.price.toString();
    }
    return EnsureVisibleWhenFocused(
        focusNode: _priceFocusNode,
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Product Price'),
          keyboardType: TextInputType.number,
          controller: _priceTextController,
          // initialValue: product == null ? '' : product.price.toString(),
          validator: (String value) {
            if (value.isEmpty ||
                !RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(value)) {
              return 'Price is required and should be a number.';
            }
            return null;
          },
        ));
  }

  Widget _buildSaveButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.isLoading
          ? Center(child: AdaptiveProgressIndicator())
          : RaisedButton(
              textColor: Colors.white,
              child: Text('Save'),
              onPressed: () => _submitForm(
                  model.addProduct,
                  model.updateProduct,
                  model.selectProduct,
                  model.selectedProductIndex),
            );
    });
  }

  void _setLocation(LocationData locData) {
    _formData['location']  = locData;
  }

  void _setImage(File image) {
      _formData['image'] = image;
  }

  _submitForm(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [int selectedProductIndex]) {
    if (!_formKey.currentState.validate() || (_formData['image'] == null && selectedProductIndex == -1)) {
      return;
    }
    _formKey.currentState.save();
    selectedProductIndex == -1
        ? addProduct(
            _titleTextController.text,
            _descriptionTextController.text,
            _formData['image'],
            double.parse(_priceTextController.text.replaceFirst(RegExp(r','), '.')),
            _formData['location']
          ).then((bool success) {
            if (success) {
              Navigator.pushReplacementNamed(context, '/products')
                  .then((_) => setSelectedProduct(null));
            } else {
              showDialog(context: context, builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Something went wrong'),
                  content: Text('Please try again'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                );
              });
            }
          })
        : updateProduct(
            _titleTextController.text,
            _descriptionTextController.text,
            _formData['image'],
            double.parse(_priceTextController.text.replaceFirst(RegExp(r','), '.')),
            _formData['location']
          ).then((_) => Navigator.pushReplacementNamed(context, '/products')
            .then((_) => setSelectedProduct(null)));
  }

  Widget _buildPageContent(BuildContext context, MainModel model) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
            margin: EdgeInsets.all(10.0),
            child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
                  children: <Widget>[
                    _buildTitleTextField(model.selectedProduct),
                    _buildDescriptionTextField(model.selectedProduct),
                    _buildPriceTextField(model.selectedProduct),
                    LocationInput(_setLocation, model.selectedProduct),
                    SizedBox(height: 10.0),
                    ImageInput(_setImage, model.selectedProduct),
                    SizedBox(height: 10.0),
                    _buildSaveButton(),
                    SizedBox(height: 15.0)
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Widget pageContent = _buildPageContent(context, model);
      return model.selectedProductIndex == -1
          ? pageContent
          : Scaffold(
              appBar: AppBar(
                title: Text('Edit Product'),
                elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 3.0,
              ),
              body: pageContent,
            );
    });
  }
}
