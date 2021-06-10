import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loading_animations/loading_animations.dart';
import './flowerDetails.dart';

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
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.flowerName + " Flower")),
      body: Container(
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Container(
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
          Container(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TextFormField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: widget.flowerName,
                    labelText: 'Update the Flower Name'),
                controller: nameController,
                //initialValue: widget.flowerName,
              ),
              TextFormField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: widget.flowerDes,
                    labelText: 'Update the Flower Description'),
                controller: descriptionController,
                //initialValue: widget.flowerDes,
              ),
              ElevatedButton(
                onPressed: () => {
                  updateFlower(widget.flowerID, nameController.text, descriptionController.text, widget.flowerImage)
                },
                child: Text("Update"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.amber.shade700,
                ),
              ),
            ],
          ))
        ]),
      ),
    );
  }
}

updateFlower(id, name, description, image) async {
  await FirebaseFirestore.instance.collection("flowers").doc(id).update({
    'name': name,
    'img': image,
    'description': description
  })
   .then((value) => print("Flower Updated"));

}
