import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  ImagePickerWidget(this._getUserImage);
  final void Function(File _userPickedImage) _getUserImage;
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File _pickedImageFile;

  void _onTakengPicture() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
    widget._getUserImage(_pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile) : null,
        ),
        TextButton.icon(
          onPressed: _onTakengPicture,
          icon: Icon(Icons.image),
          label: Text('Take Picture'),
        )
      ],
    );
  }
}
