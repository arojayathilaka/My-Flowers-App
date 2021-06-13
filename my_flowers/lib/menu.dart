import 'package:flutter/material.dart';
import 'package:my_flowers/camera.dart';
import 'package:my_flowers/main.dart';

class Menu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MenuState();
  }
}

class MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Flower App'),
        ),
        body: Center(
            child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.all(25),
            child: ElevatedButton(
              child: Text(
                'View My Flowers',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyFlowers()));
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: ElevatedButton(
              child: Text(
                'Add New Flowers',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Camera()));
              },
            ),
          ),
        ])));
  }
}
