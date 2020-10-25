import "package:flutter/material.dart";

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  Products(this.products);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(products[index]['image']),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Text(
                products[index]['title'],
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Oswald'
                ),
              ),
              SizedBox(width: 8.0,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
                decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(5.0)),
                child: Text('\$${products[index]['price'].toString()}', style: TextStyle(color: Colors.white),)
              )
            ],),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('Details'),
                onPressed: () => Navigator.pushNamed<bool>(context, '/product/' + index.toString())
              )
          ])
        ],
      ),
    );
  }

  Widget _buildProductList(BuildContext context) {
    return products.length > 0
        ? ListView.builder(
            itemBuilder: _buildProductItem,
            itemCount: products.length,
          )
        : Center(
            child: Text('No Records'),
          );
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductList(context);
  }
}
