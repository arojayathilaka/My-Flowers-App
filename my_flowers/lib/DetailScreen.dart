import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class DetailScreen extends StatefulWidget {
  var flowerName;
  var flowerDes;
  var flowerID;
  var flowerImage;

  DetailScreen(
      {Key key,
      this.flowerName,
      this.flowerDes,
      this.flowerID,
      this.flowerImage})
      : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  File imageUrl;
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  PickedFile image;
  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.flowerName + " Flower")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            (imageUrl != null)
                ? Image.file(imageUrl, width: 3000, height: 300)
                : Container(
                    width: 300,
                    height: 300,
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.flowerImage),
                        )),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () {
                  updateImage();
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
                  border: OutlineInputBorder(), hintText: widget.flowerName),
              controller: nameController,
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: widget.flowerDes),
              controller: descriptionController,
            ),
            ElevatedButton(
              child: Text('Update'),
              style: ElevatedButton.styleFrom(
                primary: Colors.amber.shade700,
              ),
              onPressed: () {
                (file != null)
                    ? sendImageToStorage(file)
                    : updateNewFlowerToFirestore(widget.flowerImage);
              },
            ),
          ],
        ),
      ),
    );
  }

  updateImage() async {
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
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }

  sendImageToStorage(File file) async {
    final _storage = FirebaseStorage.instance;

    var snapshot =
        await _storage.ref().child(file.path.split('/').last).putFile(file);

    await snapshot.ref
        .getDownloadURL()
        .then((downloadUrl) => updateNewFlowerToFirestore(downloadUrl));
  }

  updateNewFlowerToFirestore(String imageUrl) {
    if (descriptionController.text == "") {
      descriptionController.text = widget.flowerDes;
    }
    if (nameController.text == "") {
      nameController.text = widget.flowerName;
    }
    var myFlower = {
      'description': descriptionController.text,
      'img': imageUrl,
      'name': nameController.text,
    };

    var collection =
        FirebaseFirestore.instance.collection('flowers').doc(widget.flowerID);
    collection
        .update(myFlower) // <-- Update data
        .then((value) => showAlertDialog(context))
        .catchError((error) => print('Add failed: $error'));
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = ElevatedButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Success",
        textAlign: TextAlign.center, style: TextStyle(color: Colors.green)),
    content: Text("Flower Details updated Successfully."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
