import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../helpers/ensure_visible.dart';

class LocationInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();
  dynamic coords = {'lat': 36.19263133660091, 'lng': 44.00578426256253};
  List<Marker> allMarkers = [];

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    allMarkers.add(
      Marker(
        markerId: MarkerId('myMarker'),
        draggable: false,
        onTap: () {print('Marker Tapped');},
        position: LatLng(coords['lat'], coords['lng'])
      )
    );
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    allMarkers.add(
      Marker(
        markerId: MarkerId('myMarker'),
        draggable: false,
        onTap: () {print('Marker Tapped');},
        position: LatLng(coords['lat'], coords['lng'])
      )
    );
    super.dispose();
  }

  Future<dynamic> getStaticMap(String address) async {
    if(address.isNotEmpty) {
    final Uri uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {'address': address, 'key': 'AIzaSyB4qGTCPJNlRkroSxsoqYm_xnPUruCdK3E'}
    );
    final http.Response response  = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];
    setState(() {
      coords = decodedResponse['results'][0]['geometry']['location'];
    });
    print(coords);
    setState(() {
      allMarkers.add(
      Marker(
        markerId: MarkerId('myMarker'),
        draggable: false,
        onTap: () {print('Marker Tapped');},
        position: LatLng(coords['lat'], coords['lng'])
      )
    );
    });
    return coords;
    }
  }

  void _updateLocation() {
    if(!_addressInputFocusNode.hasFocus) {
      getStaticMap(_addressInputController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EnsureVisibleWhenFocused(
          focusNode: _addressInputFocusNode,
          child: TextFormField(
            focusNode: _addressInputFocusNode,
            controller: _addressInputController,
            decoration: InputDecoration(labelText: 'Address'),
          )
        ),
        SizedBox(height: 10.0),
        Container(
          height: 300,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(36.19263133660091, 44.00578426256253),
              zoom: 12,
            ),
            markers: Set.from(allMarkers),
            myLocationEnabled: true,
            mapType: MapType.normal,
            compassEnabled: true,
          )
        )
      ],
    );
  }
}
