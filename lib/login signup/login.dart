import 'package:flutter/material.dart';
import 'package:liveauctionsystem/home/homepage.dart';

import '../firebase/Authentication.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("login"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: email,
              decoration: InputDecoration(
                  label: Text("Username"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: "Enter Username"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: password,
              decoration: InputDecoration(
                  label: Text("Password"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: "Enter Password"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(120, 50),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero)),
                  backgroundColor: Colors.blueAccent),
              onPressed: () {
               Authentication().signin(email: email.text, password: password.text,context: context);
                // SharedPreferences sp = await SharedPreferences.getInstance();
                // sp.setBool(KEYLOGIN, true);
               // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const homepage(),));
              },
              child: Text("login",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))),
          SizedBox(
            height: 30,
          ),

          TextButton(
              onPressed: () {
              //  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const signup(),));
              },
              child: Text("Sign Up",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              )
          ),

        ],
      ),

      // body: Center(
      //   child: ElevatedButton(onPressed: () async{
      //     SharedPreferences sp = await SharedPreferences.getInstance();
      //     sp.setBool(KEYLOGIN, true);
      //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const MyHomePage(),));
      //   }, child: Text("login",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),),
      // ),
    );
  }
}