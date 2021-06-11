import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Camera extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Camera> {
  File imageUrl;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  PickedFile image;
  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Image')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            (imageUrl != null)
                ? Image.file(imageUrl)
                : Placeholder(
                    fallbackHeight: 200.0, fallbackWidth: double.infinity),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () {
                  uploadImage();
                },
                tooltip: 'Pick ImageFrom Gallery',
                child: Icon(
                  Icons.photo_size_select_actual_rounded,
                  size: 30,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Flower Name',
              ),
              controller: _nameController,
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Flower Description',
              ),
              controller: _descriptionController,
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                uploadImageToStorage(file);
              },
            ),
          ],
        ),
      ),
    );
  }

  uploadImage() async {
    final _picker = ImagePicker();

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _picker.getImage(source: ImageSource.gallery);

      if (image != null) {
        file = File(image.path);
        setState(() {
          imageUrl = file;
        });
        // print(downloadUrl);
        // uploadToFirestore(downloadUrl);

      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }

//Submit button
  uploadImageToStorage(File file) async {
    final _storage = FirebaseStorage.instance;
    //Upload to Firebase
    var snapshot =
        await _storage.ref().child(file.path.split('/').last).putFile(file);

    await snapshot.ref
        .getDownloadURL()
        .then((downloadUrl) => uploadToFirestore(downloadUrl));
  }

  uploadToFirestore(String imageUrl, ) {
    print(imageUrl);

    var myFlower = {
      'description': _descriptionController.text,
      'img': imageUrl,
      'name': _nameController.text,
    };

    var collection = FirebaseFirestore.instance.collection('flowers');
    collection.add(myFlower) // <-- Your data
        .then((_) {
// Navigate
    }).catchError((error) => print('Add failed: $error'));
  }
}
