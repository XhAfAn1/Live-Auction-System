import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase/Authentication.dart';

class admin_panel extends StatelessWidget {
  const admin_panel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
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
        child: Text("admin")
      )
    );
  }
}
