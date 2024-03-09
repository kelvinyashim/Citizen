import 'dart:io';

import 'package:ekene/model/place.dart';
import 'package:ekene/provider/user_place.dart';
import 'package:ekene/widgets/input_img.dart';
import 'package:ekene/widgets/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? selectedImg;
  PlaceLocation? selectlocation;
  String? error;
  void _savePlace() {
    final enteredTitle = _titleController.text;

    if (enteredTitle.isEmpty || selectedImg == null || selectlocation == null) {
      setState(() {
        error = "Please fill all fields";
      });
       showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:const Text('Error'),
          content: Text(error!),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:const Text('OK'),
            ),
          ],
        );
      },
    );
    return; 
  
    }

    ref
        .read(userPlacesProvider.notifier)
        .addPlace(enteredTitle, selectedImg!, selectlocation!);

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
              controller: _titleController,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 19),
            ),
            const SizedBox(height: 16),
            // imageInput
            InputImage(
              onPickedImg: (image) {
                selectedImg = image;
              },
            ),
            const SizedBox(height: 16),
            LocationInput(selectLocation: (location) {
              selectlocation = location;
            }),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _savePlace,
              icon: const Icon(Icons.add),
              label: const Text('Add Place'),
            ),
          ],
        ),
      ),
    );
  }
}
