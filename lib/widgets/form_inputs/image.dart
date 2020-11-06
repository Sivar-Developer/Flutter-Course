import 'package:flutter/material.dart';

class ImageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        OutlineButton(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.0
          ),
          onPressed: () {},
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
