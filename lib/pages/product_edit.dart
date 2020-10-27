import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/widgets/helpers/ensure_visible.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/products.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {'title': null, 'description': null, 'price': null, 'image': 'assets/food.jpg'};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  Widget _buildTitleTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
          decoration: InputDecoration(labelText: 'Product Title'),
          // autovalidate: true,
          initialValue: product == null ? '' : product.title.toString(),
          validator: (String value) {
            // if(value.trim().length <= 0) {
              if(value.isEmpty || value.length < 5) {
              return 'Title is required and should be +5 characters long.';
            }
          },
          onSaved: (String value) {
            _formData['title'] = value;
          },
        ),
      );
  }

  Widget _buildDescriptionTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
      decoration: InputDecoration(labelText: 'Product Description'),
      maxLines: 4,
      initialValue: product == null ? '' : product.description.toString(),
      validator: (String value) {
          if(value.isEmpty || value.length < 5) {
          return 'Description is required and should be +5 characters long.';
        }
      },
      onSaved: (String value) {
        _formData['description'] = value;
      },
      )
    );
  }

  Widget _buildPriceTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
      decoration: InputDecoration(labelText: 'Product Price'),
      keyboardType: TextInputType.number,
      initialValue: product == null ? '' : product.price.toString(),
      validator: (String value) {
          if(value.isEmpty || !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Price is required and should be a number.';
        }
      },
      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
      )
    );
  }

  Widget _buildSaveButton() {
    return ScopedModelDescendant<ProductsModel>(builder: (BuildContext context, Widget child, ProductsModel model) {
        return RaisedButton(
          textColor: Colors.white,
          child: Text('Save'),
          onPressed: () => _submitForm(model.addProduct, model.updateProduct, model.selectedProduct, model.selectedProductIndex),
        );
      }
    );
  }

  _submitForm(Function addProduct, Function updateProduct, Product product, [int selectedProductIndex]) {
    if(!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    selectedProductIndex == null ? addProduct(
      Product(
        title: _formData['title'],
        description: _formData['description'],
        price: _formData['price'],
        image: _formData['image']
      )
    ) : updateProduct(selectedProductIndex, 
      Product(
        title: _formData['title'],
        description: _formData['description'],
        price: _formData['price'],
        image: _formData['image']
      )
    );
    Navigator.pushReplacementNamed(context, '/products');
  }

  Widget _buildPageContent(BuildContext context, ProductsModel model) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child:Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildTitleTextField(model.selectedProduct),
              _buildDescriptionTextField(model.selectedProduct),
              _buildPriceTextField(model.selectedProduct),
              SizedBox(height: 10.0,),
              _buildSaveButton()
            ],
          )
        )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        final Widget pageContent = _buildPageContent(context, model);
        return model.selectedProductIndex == null 
        ? pageContent
        : Scaffold(
          appBar: AppBar(
            title: Text('Edit Product'),
          ),
          body: pageContent,
        );
      }
    );
  }
}
