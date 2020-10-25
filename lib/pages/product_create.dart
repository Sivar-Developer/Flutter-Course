import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String _titleValue;
  String _descriptionValue;
  double _priceValue;

  Widget _buildTitleTextField() {
    return TextField(
      decoration: InputDecoration(labelText: 'Title'),
      onChanged: (String value) {
        setState(() {
          _titleValue = value;
        });
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return TextField(
      decoration: InputDecoration(labelText: 'Description'),
      maxLines: 4,
      onChanged: (String value) {
        setState(() {
          _descriptionValue = value;
        });
      },
    );
  }

  Widget _buildPriceTextField() {
    return TextField(
      decoration: InputDecoration(labelText: 'Price'),
      keyboardType: TextInputType.number,
      onChanged: (String value) {
        setState(() {
          _priceValue = double.parse(value);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
        children: <Widget>[
        _buildTitleTextField(),
        _buildDescriptionTextField(),
        _buildPriceTextField(),
        SizedBox(height: 10.0,),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          child: Text('Save'), 
          onPressed: () {
            final Map<String, dynamic> product = {
              'title': _titleValue,
              'description': _descriptionValue,
              'price': _priceValue,
              'image': 'assets/food.jpg'
            };
            widget.addProduct(product);
            Navigator.pushReplacementNamed(context, '/products');
          },
        ),
      ],
      )
    );
  }
}
