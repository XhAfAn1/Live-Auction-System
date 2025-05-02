import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liveauctionsystem/home/private%20bidding/add%20product.dart';
import 'package:liveauctionsystem/home/private%20bidding/private%20view.dart';

import '../../classes/Product.dart';
import '../SingleProductView.dart';

class private_room extends StatefulWidget {
  const private_room({super.key});

  @override
  State<private_room> createState() => _private_roomState();
}

class _private_roomState extends State<private_room> {
  TextEditingController croomid=TextEditingController();
  TextEditingController croompass=TextEditingController();

  TextEditingController jroomid=TextEditingController();
  TextEditingController jroompass=TextEditingController();

  Future<void> createroom(String roomid, String roompass) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("private rooms")
          .doc(roomid)
          .get();

      if (!doc.exists) {
        await FirebaseFirestore.instance
            .collection("private rooms")
            .doc(roomid)
            .set({
          "roomid": roomid,
          "roompass": roompass,
          "owner": FirebaseAuth.instance.currentUser!.uid,
        });

        print("Room created successfully");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => add_private_product(croomid: roomid),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Room already exists')),
        );
        print("Room already exists");
      }


    } catch (e) {
      print("Error creating room: $e");
    }
  }


  Future<void> enterRoom(String roomid, String roompass) async {
    try {
      final roomDoc = await FirebaseFirestore.instance
          .collection("private rooms")
          .doc(roomid)
          .get();

      if (!roomDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Room does not exist')),
        );
        return;
      }

      if (roomDoc.get("roompass") != roompass) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid password')),
        );
        return;
      }

      // Fetch one product from the subcollection "products"
      final productSnapshot = await FirebaseFirestore.instance
          .collection("private rooms")
          .doc(roomid)
          .collection("products")
          .limit(1)
          .get();

      if (productSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No products found in this room')),
        );
        return;
      }

      final product = Product.fromFirestore(productSnapshot.docs.first);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => privateproductview(product: product,roomId: roomid,),
        ),
      );
    } catch (e) {
      print("Error entering room: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Private Room"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(170, 15),
                backgroundColor: Color(0xff0a3a0b),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                showDialog(context: context, builder: (context)=>AlertDialog(
                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  title: Text("Create room",style: TextStyle(color:Color(0xff0a3a0b),fontWeight: FontWeight.bold),),
                  content: Container(
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: croomid,
                            decoration: InputDecoration(
                              labelText: "Room ID",
                            ),
                          ),
                          TextField(
                            controller: croompass,
                            decoration: InputDecoration(
                              labelText: "Room Pass",
                            ),
                          ),
                          ]
                      ),
                  ),
                  actions: [
                    TextButton(onPressed: ()
                    {
                      Navigator.pop(context);
                    }, child: Text("Cancel")),

                    TextButton(onPressed: ()
                    {

                      createroom(croomid.text, croompass.text);
                   //   Navigator.pop(context);
                    }, child: Text("Create"))
                  ],

                ));
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(builder: (context) => ),
                // );
              },
              child: const Text(
                "Create Room",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(170, 15),
                backgroundColor: Color(0xff0a3a0b),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                showDialog(context: context, builder: (context)=>AlertDialog(
                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  title: Text("Join room",style: TextStyle(color:Color(0xff0a3a0b),fontWeight: FontWeight.bold),),
                  content: Container(
                    height: 150,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: jroomid,
                            decoration: InputDecoration(
                              labelText: "Room ID",
                            ),
                          ),
                          TextField(
                            controller: jroompass,
                            decoration: InputDecoration(
                              labelText: "Room Pass",
                            ),
                          ),
                        ]
                    ),
                  ),
                  actions: [
                    TextButton(onPressed: ()
                    {
                      Navigator.pop(context);
                    }, child: Text("Cancel")),

                    TextButton(onPressed: ()
                    {
                    enterRoom(jroomid.text, jroompass.text);


                     // Navigator.pop(context);
                    }, child: Text("Enter"))
                  ],

                ));
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(builder: (context) => ),
                // );
              },
              child: const Text(
                "Enter Room",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
