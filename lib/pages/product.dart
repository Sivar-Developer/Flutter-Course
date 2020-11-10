import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/widgets/products/address_tag.dart';
import 'package:flutter_course/widgets/products/price_tag.dart';
import 'package:flutter_course/widgets/products/product_fab.dart';
import 'package:flutter_course/widgets/ui_elements/title_default.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/product.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  ProductPage(this.product);

  @override
  State<StatefulWidget> createState() {
    return ProductPageState();
  }
}
class ProductPageState extends State<ProductPage> {
  List<Marker> allMarkers = [];

  @override
  void initState() {
    allMarkers.add(
      Marker(
        markerId: MarkerId('myMarker'),
        draggable: false,
        onTap: () {print('Marker Tapped');},
        position: LatLng(widget.product.location.latitude, widget.product.location.longitude)
    ));
    super.initState();
  }

  Future<dynamic> _showMap(BuildContext context) {
      return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context)
          .modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext,
          Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 10,
            height: 550,
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 500,
                  child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(36.19263133660091, 44.00578426256253),
                    zoom: 12,
                  ),
                  markers: Set.from(allMarkers),
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  compassEnabled: true,
                ),
                )
              ],
            ),
          ),
        );
      });
  }

  Widget _buildTitlePriceRow(double price, String title) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Expanded(
          child: TitleDefault(title)
        ),
        SizedBox(width: 8.0,),
        PriceTag(price.toString()),
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      print('Back button pressed!');
      Navigator.pop(context, false);
      return Future.value(true);
    }, child: Scaffold(
        // appBar: AppBar(
        //   title: Text(widget.product.title),
        // ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 220.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.product.title),
                background: Hero(
                  tag: widget.product.id,
                  child: FadeInImage(
                    image: NetworkImage(widget.product.image),
                    placeholder: AssetImage('assets/placeholder.png'),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildTitlePriceRow(widget.product.price, widget.product.title),
                GestureDetector(
                  onTap: () => _showMap(context),
                  child: AddressTag(widget.product.location.address),
                ),
                Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  widget.product.description,
                  textAlign: TextAlign.center
                  )
                ),
              ]),
            )
          ],
        ),
        floatingActionButton: ProductFab(widget.product)
      )
    );
  }
}