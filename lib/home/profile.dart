import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../classes/user.dart';

class profile extends StatelessWidget {
final String uid;
  const profile({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Profile"),
      ),
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(future: FirebaseFirestore.instance.collection("Users").doc(uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: CircularProgressIndicator(), // Show a loading indicator
                );
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Text("No Data");
              }


              UserModel user= UserModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                return ListView(
                  padding: EdgeInsets.all(20),
                  scrollDirection: Axis.vertical,
                  children: [
                    SizedBox(height: 20,),
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(user.profileImageUrl),
                    ),
                    SizedBox(height: 20,),
                    Text("Name: ${user.name}"),
                    SizedBox(height: 20,),
                    Text("Email: ${user.email}"),
                    SizedBox(height: 20,),
                    Text("Phone Number: ${user.phoneNumber}"),
                    SizedBox(height: 20,),
                    Text("Address: ${user.address}"),
                    SizedBox(height: 20,),

                  ],
                );

            },),
    )
    );
  }
}
