import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase/Authentication.dart';
import '../home/profile.dart';
import '../main.dart';

class admin_panel extends StatefulWidget {
  const admin_panel({super.key});

  @override
  State<admin_panel> createState() => _admin_panelState();
}

class _admin_panelState extends State<admin_panel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
        actions: [
          //if(FirebaseAuth.instance.currentUser != null)
          Container(
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .get(),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    child: CircularProgressIndicator(
                      padding: EdgeInsets.all(13),
                      strokeWidth: 0.7,
                    ),
                  );
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return InkWell(
                    splashFactory: NoSplash.splashFactory,
                    radius: 50,
                    onTap: (){
                      if(FirebaseAuth.instance.currentUser == null)
                        showLogDiag(context);
                      else
                        Navigator.push(context, MaterialPageRoute(builder: (context) => profile(uid: FirebaseAuth.instance.currentUser!.uid,),));
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, size: 20, color: Colors.white),
                    ),
                  );
                }

                String? imageUrl = snapshot.data!.get("profileImageUrl");

                return InkWell(
                  splashFactory: NoSplash.splashFactory,
                  radius: 50,

                  onTap: (){
                    if(FirebaseAuth.instance.currentUser == null)
                      showLogDiag(context);
                    else
                      Navigator.push(context, MaterialPageRoute(builder: (context) => profile(uid: FirebaseAuth.instance.currentUser!.uid,),));
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                        ? NetworkImage(imageUrl)
                        : null,
                    backgroundColor: Colors.grey[300],
                    child: (imageUrl == null || imageUrl.isEmpty)
                        ? Icon(Icons.person, size: 20, color: Colors.white)
                        : null,
                  ),
                );
              },
            ),
          ),




          Container(
            width: 20,
          )
        ],
      ),
        drawer: Drawer(

          backgroundColor: Colors.white,
          width: 280,
          child: ListView(
            children: [
              SizedBox(height: 100,),
              if(FirebaseAuth.instance.currentUser != null)
                IconButton(onPressed: (){
                  Authentication().signout(context);
                }, icon: Icon(Icons.logout)),
              SizedBox(height: 20,),

            ],
          ),
        ),
      body: Center(
        child: Image.asset("assets/bird.gif"),
      )
    );
  }
}
