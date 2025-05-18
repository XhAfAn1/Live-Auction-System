import 'dart:async';

import 'package:flutter/material.dart';
import 'package:liveauctionsystem/home/homepage.dart';
import 'package:liveauctionsystem/login%20signup/signup.dart';

import '../firebase/Authentication.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  String btn_text="Log in";
  bool isloading=false;
  bool loading=false;
  @override
  Widget build(BuildContext context) {



    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    if(loading)
      return Scaffold(
        body: Center(
         // child: Image.asset("assets/hammer.gif"),
          child: CircularProgressIndicator(),
        ),
      );
    else
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
                backgroundColor: Color(0xff093125),
                foregroundColor: Colors.white,
                elevation: 1,
                // padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () async{

                setState(() {
                  loading=true;
                  btn_text="Logging in...";
                });
               isloading=await Authentication().signin(email: email.text.trim(), password: password.text,context: context);

              if(!isloading){
                Timer(Duration(milliseconds: 50), () {
                  setState(() {
                    loading=false;
                    btn_text="Log in";
                  });
                });
              }


              },
              child: Text(btn_text,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))),
          SizedBox(
            height: 30,
          ),

          TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const signup(),));
              },
              child: Text("Sign Up",
                style: TextStyle(
                    color: Color(0xff0a3a0b),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              )
          ),

        ],
      ),
    );
  }
}