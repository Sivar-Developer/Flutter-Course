import 'package:flutter/material.dart';

class ImageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return Container(
        height: 150,
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Text('Pick an Image', style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 5.0),
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              onPressed: () {},
              child: Text('Use camera'),
            ),
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              onPressed: () {},
              child: Text('Use Gallery'),
            )
          ]
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        OutlineButton(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.0
          ),
          onPressed: () => _openImagePicker(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
              SizedBox(width: 5.6),
              Text('Add Image', 
                style: TextStyle(
                  color: Theme.of(context).primaryColor),
                )
            ]
          ),
        )
      ],
    );
  }
}
