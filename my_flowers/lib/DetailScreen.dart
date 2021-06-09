import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loading_animations/loading_animations.dart';
import './main.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.flowerName + " Flower")),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
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
                    labelText: 'Enter the Flower Name'),
                    initialValue: widget.flowerName,
              ),
              TextFormField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter the Flower Description'),
                    initialValue: widget.flowerDes,
              )
            ],
          ))
        ]),
      ),
    );
  }
}
