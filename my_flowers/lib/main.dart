import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loading_animations/loading_animations.dart';
import './DetailScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: "My Flowers",
    theme: ThemeData(

      brightness: Brightness.dark,
      primaryColor: Colors.amber.shade500,
      accentColor: Colors.amber.shade700,

      fontFamily: 'Georgia',
  ),
    home: MyFlowers(),
  ));
}

class MyFlowers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyFlowers();
  }
  
}

class _MyFlowers extends State<MyFlowers> with TickerProviderStateMixin {
  // @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.6;
    return Scaffold(
        backgroundColor: Colors.amber.shade50,      
        appBar: AppBar(
          title: Text("My Flowers"),
          backgroundColor: Colors.amber.shade400,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("flowers").snapshots(),
          builder: (context, snapshot) {
            
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                  "Somethin went wrong.",
                  style: TextStyle(fontSize: 20.0),
              ));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingFadingLine.circle(
                    borderColor: Colors.amber.shade700,
                    borderSize: 10.0,
                    size: 50.0,
                    backgroundColor: Colors.amber.shade600),
              );
            }

            if ((snapshot.data as QuerySnapshot).docs.length == 0) {
              return Center(
                  child: Text(
                    "No flowers are available.",
                    style: TextStyle(fontSize: 20.0),
              ));
            } else {
              return ListView.builder(
                itemCount: (snapshot.data as QuerySnapshot).docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot flower =
                      (snapshot.data as QuerySnapshot).docs[index];
                  //print(flower);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => DetailScreen(flowerName: flower['name'], flowerDes: flower['description'], flowerID: flower.id, flowerImage: flower['img']),
                  ),
                );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            // child: Image.network(flower['img']),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(flower['img']),
                              )
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    flower['name'],
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.amber.shade700,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: width,
                                    child: Text(
                                      flower['description'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey
                                      ),
                                    )
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
