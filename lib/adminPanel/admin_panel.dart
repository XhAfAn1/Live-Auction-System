import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liveauctionsystem/classes/user.dart';

import '../firebase/Authentication.dart';
import '../home/profile.dart';
import '../main.dart';

class admin_panel extends StatefulWidget {
  const admin_panel({super.key});

  @override
  State<admin_panel> createState() => _admin_panelState();
}

class _admin_panelState extends State<admin_panel> {
int pid=1;


  panelid(int id){

    //homepage
    if(id==1){
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 20,crossAxisSpacing: 20),children: [

                Container(
                    width: 170,
                    height: 150,
                    color: Colors.red[200],
                    child: FutureBuilder(
                      future: FirebaseFirestore.instance.collection("products").get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Products"),
                                Expanded(child: Center(child: Text("0",style: TextStyle(fontSize: 30))))
                              ],
                            ),
                          );
                        }
                        else if (snapshot.hasData) {
                          // return Center(child: Text("Total Products: ${snapshot.data!.docs.length}"));
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Products"),
                                Expanded(child: Center(child: Text("${snapshot.data!.docs.length}",style: TextStyle(fontSize: 30),)))
                              ],
                            ),
                          );
                        }
                        return Text("Data not found");
                      } ,)
                ),
                Container(
                    width: 170,
                    height: 150,
                    color: Colors.green[200],
                    child: FutureBuilder(
                      future: FirebaseFirestore.instance.collection("Users").get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Users"),
                                Expanded(child: Center(child: Text("0",style: TextStyle(fontSize: 30))))
                              ],
                            ),
                          );
                        }
                        else if (snapshot.hasData) {
                          // return Center(child: Text("Total Products: ${snapshot.data!.docs.length}"));
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Users"),
                                Expanded(child: Center(child: Text("${snapshot.data!.docs.length}",style: TextStyle(fontSize: 30),)))
                              ],
                            ),
                          );
                        }
                        return Text("Data not found");
                      } ,)
                ),
                Container(
                    width: 170,
                    height: 150,
                    color: Colors.blue[200],
                    child: FutureBuilder(
                      future: FirebaseFirestore.instance.collection("products").get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Sell"),
                                Expanded(child: Center(child: Text("0 ৳",style: TextStyle(fontSize: 30))))
                              ],
                            ),
                          );
                        }
                        else if (snapshot.hasData) {
                          // return Center(child: Text("Total Products: ${snapshot.data!.docs.length}"));
                          final docs = snapshot.data!.docs;
                          int totalSum = docs.fold<int>(0, (prev, doc) {
                            if (doc['status'] == 'ended') {
                              final price = doc['currentPrice'];
                              return prev + (price is int ? price : 0);
                            } else {
                              return prev;
                            }
                          });

                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Sell"),
                                Expanded(child: Center(child: Text("$totalSum ৳",style: TextStyle(fontSize: 30),)))
                              ],
                            ),
                          );
                        }
                        return Text("Data not found");
                      } ,)
                ),
                Container(
                  width: 170,
                  height: 150,
                  color: Colors.yellow[200],
                ),
                Container(
                  width: 170,
                  height: 150,
                  color: Colors.teal[200],
                ),
                Container(
                  width: 170,
                  height: 150,
                  color: Colors.pink[200],
                ),

              ],),
            ),

          ],
        ),
      );
    }

    //show All users
    if(id==2){
      return  FutureBuilder(
        future: FirebaseFirestore.instance.collection("Users").get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            final users = docs.map((doc) => UserModel.fromJson(doc.data())).toList();
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 100,
                            width:100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey[300],
                                image: DecorationImage(fit: BoxFit.fitWidth, image:user.profileImageUrl.isNotEmpty
                                    ? NetworkImage(user.profileImageUrl): NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/HD_transparent_picture.png/1200px-HD_transparent_picture.png"))
                            ),

                            child: user.profileImageUrl.isEmpty ? Icon(Icons.person,color: Colors.white,) : null,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Text(user.name,style: TextStyle(fontWeight: FontWeight.bold),),
                                Text("Email: ${user.email}"),
                                Text("Phone: ${user.phoneNumber}"),
                                Text("Address: ${user.address}"),
                                Text("Admin: ${user.admin ? "Yes" : "No"}"),
                                Text("Joined: ${user.createdAt.toLocal().toString().split(' ')[0]}"),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          )
                        ],
                      )

                    ],
                    ),
                );
              },
            );
          } else {
            return Center(child: Text("No users found."));
          }
        },
      );

    }

    //show all products


  }


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
              ListTile(
                title: Text("Home"),
                onTap: (){
                  setState(() {
                    pid=1;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("show all user"),
                onTap: (){
                  setState(() {
                    pid=2;
                  });
                  Navigator.pop(context);
                },
              ),
              if(FirebaseAuth.instance.currentUser != null)
                IconButton(onPressed: (){
                  Authentication().signout(context);
                }, icon: Icon(Icons.logout)),
              SizedBox(height: 20,),

            ],
          ),
        ),
      body:panelid(pid)
    );
  }
}
