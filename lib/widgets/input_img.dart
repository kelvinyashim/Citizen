import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InputImage extends StatefulWidget {
  final void Function(File image) onPickedImg;
  const InputImage({super.key, required this.onPickedImg});

  @override
  State<InputImage> createState() => _InputImageState();
}

class _InputImageState extends State<InputImage> {
  File? selectedImg;
  void takePicture() async {
    //
    final imagePicker = ImagePicker();
    final pickedImg =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (pickedImg == null) {
      return;
    }
    setState(() {
      selectedImg = File(pickedImg.path);
    });
    widget.onPickedImg(selectedImg!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
        onPressed: takePicture,
        icon: Icon(Icons.camera),
        label: Text('Upload Image'));

    if (selectedImg != null) {
      return GestureDetector(
        onTap: () => takePicture(),
        child: Image.file(
          selectedImg!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 400,
        ),
      );
    }

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
        ),
        width: double.infinity,
        height: 300,
        alignment: Alignment.center,
        child: content);
  }
}
