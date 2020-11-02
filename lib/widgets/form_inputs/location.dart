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

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  Future<dynamic> getStaticMap(String address) async {
    final Uri uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {'address': address, 'key': 'AIzaSyB4qGTCPJNlRkroSxsoqYm_xnPUruCdK3E'}
    );
    final http.Response response  = await http.get(uri);
    return;
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
              zoom: 15,
            ),
            myLocationEnabled: true,
            mapType: MapType.normal,
            compassEnabled: true,
          )
        )
      ],
    );
  }
}
