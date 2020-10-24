import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String titleValue;
  String descriptionValue;
  double priceValie;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
        TextField(
          decoration: InputDecoration(labelText: 'Title'),
          onChanged: (String value) {
            setState(() {
              titleValue = value;
            });
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Description'),
          maxLines: 4,
          onChanged: (String value) {
            setState(() {
              descriptionValue = value;
            });
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Price'),
          keyboardType: TextInputType.number,
          onChanged: (String value) {
            setState(() {
              priceValie = double.parse(value);
            });
          },
        ),
      ],
      )
    );
  }
}
