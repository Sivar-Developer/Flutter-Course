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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
        TextField(
          decoration: InputDecoration(labelText: 'Title'),
          onChanged: (String value) {
            setState(() {
              _titleValue = value;
            });
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Description'),
          maxLines: 4,
          onChanged: (String value) {
            setState(() {
              _descriptionValue = value;
            });
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Price'),
          keyboardType: TextInputType.number,
          onChanged: (String value) {
            setState(() {
              _priceValue = double.parse(value);
            });
          },
        ),
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
