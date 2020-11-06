import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {

  void _pickImage(ImageSource source) async {
    PickedFile image = await ImagePicker().getImage(source: source, maxWidth: 400.0);
    print(image);
    Navigator.pop(context);
  }

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
              child: Text('Use camera'),
              onPressed: () {
                _pickImage(ImageSource.camera);
              },
            ),
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: Text('Use Gallery'),
              onPressed: () {
                _pickImage(ImageSource.gallery);
              },
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
