import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase/Authentication.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    print(user);
    return Scaffold(
backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

          //  Text(user!.toString()),


           Expanded(
             child: StreamBuilder(stream: FirebaseFirestore.instance.collection("Users").snapshots(), builder: (context,snapshot){
               if(snapshot.connectionState==ConnectionState.waiting){
                 return Center(child: CircularProgressIndicator(),);
               }
               else if(snapshot.hasError){
                 return Center(child: Text(snapshot.error.toString()),);
               }
               else
                 return ListView.builder(
                     itemCount: snapshot.data!.docs.length,
                     itemBuilder: (context,index){
                       var data = snapshot.data!.docs[index];
                      return ListTile(title: Text(data['email'],style: TextStyle(color: data['email']==user!.email ? Colors.red: Colors.blue,fontSize: 30),),
                     // subtitle: Text(data['isEmailVerified']!.toString()),
                      );
                 });

             })),


            ElevatedButton(onPressed: (){
              Authentication().signout(context);
            }, child: Text("Logout")),
           SizedBox(height: 20,)


          ],
        )
      ),
    );
  }
}
