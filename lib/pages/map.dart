import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MapPageState();
  }
}

class MapPageState extends State<MapPage> {
  GoogleMapController mapController;
  Location location = new Location();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GoogleMap(initialCameraPosition: CameraPosition(
          target: LatLng(36.19263133660091, 44.00578426256253),
          zoom: 15,
        ),
        myLocationEnabled: true,
        mapType: MapType.normal,
        compassEnabled: true,
      ),
      Positioned(
        bottom: 50,
        right: 10,
        child: 
          FlatButton(
            child: Icon(Icons.pin_drop, color: Colors.white,),
            color: Colors.green,
            onPressed: _addMarker,
          )
      )
    ],);
  }

  _addMarker() {
    Marker(
      markerId: MarkerId('what'),
      position: LatLng(36.19263133660091, 44.00578426256253),
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: 'Magic Marker', snippet: 'ssdsdsd')
    );
    return mapController.showMarkerInfoWindow(MarkerId('what'));
  }

  // _onMapCreated(GoogleMapController controller) {
  //   setState(() {
  //     //
  //   });
  // }
}