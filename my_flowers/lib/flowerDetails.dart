import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:fluttertoast/fluttertoast.dart';


showFlowerDetailsPopup(context,name,img,description,id){



  return showDialog(
      context: context,
      builder: (context){
        return Center(
            child:Material(
                type:MaterialType.transparency,
                child:Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.yellow[100],
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 13.0,
                          color: Colors.white.withOpacity(.8),
                          offset: Offset(6.0, 7.0),
                        ),
                      ],
                    ),


                    padding: EdgeInsets.all(15),
                    width:MediaQuery.of(context).size.width * 0.8,
                    height: 450,
                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          Container(
                            width: 100,
                            height: 100,
                            // child: Image.network(flower['img']),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(img),
                                )
                            ),
                          ),


                          SizedBox(height: 10,),
                          Text(
                              name,
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              )
                          ),

                          SizedBox(height: 10,),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[800],

                            ),
                            textAlign: TextAlign.center,
                          ),


                          Padding(
                              padding: const EdgeInsets.all(60.0),
                              child: Row(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,


                                children: <Widget>[
                                  ElevatedButton(

                                    onPressed: () => {
                                      deleteFlower(id,name)
                                    },
                                    child: Text("Delete"),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.amber.shade700,

                                    ),

                                  ),

                                  ElevatedButton(

                                    onPressed: (
                                        //updateFlower()
                                        ){},
                                    child: Text("Update"),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.amber.shade700,

                                    ),


                                  )

                                ],
                              ))


                        ]

                    )

                )
            )

        );
      }
  );

}



deleteFlower(id,name) async {

  await FirebaseFirestore.instance.collection("flowers").doc(id).delete();

  Fluttertoast.showToast(
      msg: name + " flower deleted!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      //backgroundColor: Colors.red[100],
      textColor: Colors.grey[100],
      fontSize: 16.0
  );

}


