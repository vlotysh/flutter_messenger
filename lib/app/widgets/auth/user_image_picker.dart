import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File userImage) userImageHandler;

  UserImagePicker(this.userImageHandler);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _imageFile;

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.getImage(
        source: ImageSource.camera,
        maxWidth: 600,
        maxHeight: 600,
        preferredCameraDevice: CameraDevice.front);

    final imageFile = File(image.path);

    setState(() {
      _imageFile = imageFile;
    });

    widget.userImageHandler(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: _imageFile != null ? FileImage(_imageFile) : null,
          radius: 40,
        ),
        FlatButton.icon(
            textColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.image),
            onPressed: _pickImage,
            label: Text('Add image'))
      ],
    );
  }
}
