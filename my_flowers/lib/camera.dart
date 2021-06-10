// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

// class Camera extends StatefulWidget {
//   @override
//   _CameraState createState() => _CameraState();
// }

// class _CameraState extends State<Camera> {
//   TextEditingController _userNameController = TextEditingController();
//   final List<String> errors = [];
//   final _formKey = GlobalKey<FormState>();
//   String name = '';
//   // String password;
//   File? _image;
//   final picker = ImagePicker();

//   void addError({String? error}) {
//     if (!errors.contains(error))
//       setState(() {
//         errors.add(error!);
//       });
//   }

//   void removeError({String? error}) {
//     if (errors.contains(error))
//       setState(() {
//         errors.remove(error);
//       });
//   }

//   Future getImageGallery() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   Future getImageCamera() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add New Flowers'),
//       ),
//       body: SingleChildScrollView(
//               child: Column(
//           children: [
//             Container(
//               width: 300,
//               height: 300,
//               alignment: Alignment.center,
//               margin: const EdgeInsets.only(
//                 left: 60.0,
//                 right: 60.0,
//                 top: 20,
//               ),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Colors.orange,
//                   width: 4,
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: _image == null
//                   ? Text('No image selected.')
//                   : Image.file(
//                       _image!,
//                       height: 300,
//                       width: 300,
//                     ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 20,),
//               child: new Container(
//                 child: buildNameFormField(),
//               ),
//             ),
//             // ElevatedButton(onPressed: onPressed, child: child)
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: getImageGallery,
//         tooltip: 'Pick ImageFrom Gallery',
//         child: Icon(
//           Icons.photo_size_select_actual_rounded,
//           size: 30,
//         ),
//       ),
//     );
//   }

//   TextFormField buildNameFormField() {
//     return TextFormField(
//       style: TextStyle(color: Colors.grey),
//       onSaved: (newValue) => name,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           removeError(error: "Please Enter Flower Name");
//         }
//         return null;
//       },
//       validator: (value) {
//         if (value!.isEmpty) {
//           addError(error: "Please Enter Flower Name");
//           return "";
//         }
//         return null;
//       },
//       controller: _userNameController,
//       decoration: InputDecoration(
//         labelText: "Flower Name",
//         labelStyle: TextStyle(
//           color: Colors.grey,
//         ),
//         hintText: "Enter Flower Name", hintStyle: TextStyle(color: Colors.grey),
//         // If  you are using latest version of flutter then lable text and hint text shown like this
//         // if you r using flutter less then 1.20.* then maybe this is not working properly
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//       ),
//     );
//   }

// }

// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';

// class Camera extends StatefulWidget {
//   @override
//   _CameraState createState() => _CameraState();
// }

// class _CameraState extends State<Camera> {
//   File? imageFile;
//   final picker = ImagePicker();

//   _openGallery(BuildContext context) async {
//     var picture = await picker.getImage(source: ImageSource.gallery);
//     this.setState(() {
//       imageFile = File(picture!.path);
//     });
//   }

// _openCamera(BuildContext context) async {
//   var picture = await picker.getImage(source: ImageSource.camera);
//   this.setState(() {
//     imageFile = File(picture!.path);
//   });
// }

// Future<void> _showChoiceDialog(BuildContext context) {
//   return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Choose Image"),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 GestureDetector(
//                   child: Text("Gallery"),
//                   onTap: _openGallery(context),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                 ),
//                 GestureDetector(
//                   child: Text("Gallery"),
//                   onTap: _openCamera(context),
//                 ),
//               ],
//             ),
//           ),
//         );
//       });
// }

//   Widget _decideImageView(){
//     if(imageFile == null){
//       return Text("No Image Selected");
//     }
//     else{
//       Image.file(imageFile!,width: 450,height: 450,);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: AppBar(
//         title: Text('Camera'),
//       ),
//       body: Container(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               _decideImageView();
//               ElevatedButton(
//                   onPressed: () {
//                     _openGallery(context);
//                   },
//                   child: Text("Select Image"))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
