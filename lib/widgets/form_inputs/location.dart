import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_course/models/location_data.dart';
import 'package:flutter_course/models/product.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as geoloc;

import '../helpers/ensure_visible.dart';

class LocationInput extends StatefulWidget {
  final Function setLocation;
  final Product product;

  LocationInput(this.setLocation, this.product);

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  LocationData _locationData;
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();
  List<Marker> allMarkers = [];

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    if(widget.product != null) {
      _getLocationMarker(widget.product.location.address, geocode: false);
    }
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  Future<dynamic> _getLocationMarker(String address, {bool geocode = true, double lat, double lng}) async {
    if(address.isNotEmpty) {
      if(geocode) {
        final Uri uri = Uri.https(
          'maps.googleapis.com',
          '/maps/api/geocode/json',
          {'address': address, 'key': 'AIzaSyB4qGTCPJNlRkroSxsoqYm_xnPUruCdK3E'}
        );
        final http.Response response  = await http.get(uri);
        final decodedResponse = json.decode(response.body);
        final formattedAddress = decodedResponse['results'][0]['formatted_address'];
        final coords = decodedResponse['results'][0]['geometry']['location'];
        _locationData = LocationData(address: formattedAddress, latitude: coords['lat'], longitude: coords['lng']);
      } else if(lat == null && lng == null) {
        _locationData = widget.product.location;
      } else {
        _locationData = LocationData(address: address, latitude: lat, longitude: lng);
      }

      widget.setLocation(_locationData);

      if(mounted) {
        setState(() {
          _addressInputController.text = _locationData.address;
          allMarkers.add(
          Marker(
            markerId: MarkerId('myMarker'),
            draggable: false,
            onTap: () {print('Marker Tapped');},
            position: LatLng(_locationData.latitude, _locationData.longitude)
          )
        );
        });
      }
    }
  }

  Future<String> _getAddress(double lat, double lng) async {
    final uri = Uri.https(
          'maps.googleapis.com',
          '/maps/api/geocode/json',
          {'latlng': '${lat.toString()},${lng.toString()}', 'key': 'AIzaSyB4qGTCPJNlRkroSxsoqYm_xnPUruCdK3E'}
        );
    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];
    return formattedAddress;
  }

  void _getUserLocation() async {
    try {
      final currentLocation = await geoloc.Location().getLocation();
      final address = await _getAddress(currentLocation.latitude, currentLocation.longitude);
      _getLocationMarker(address, geocode: false, lat: currentLocation.latitude, lng: currentLocation.longitude);
    } catch(error) {
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Could not fetch user location'),
          content: Text('Please add address manually'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Okey'),
            )
          ],
          );
      });
    }
  }

  void _updateLocation() {
    if(!_addressInputFocusNode.hasFocus) {
      _getLocationMarker(_addressInputController.text);
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
            validator: (String value) {
              if(_locationData == null ||  value.isEmpty) {
                return 'No valid location found';
              }
              return null;
            },
            decoration: InputDecoration(labelText: 'Address'),
          )
        ),
        SizedBox(height: 10.0),
        FlatButton(
          child: Text('Locate User'),
          onPressed: _getUserLocation,
        ),
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
