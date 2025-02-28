import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home/homepage.dart';
import '../login signup/login.dart';

class Authentication {




  Future<void> signin(
      {required String email, required String password,context}) async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      User? user = FirebaseAuth.instance.currentUser;
      print("success");
      print(FirebaseAuth.instance.currentUser);
      await Future.delayed(Duration(seconds: 1));
      // SharedPreferences sp = await SharedPreferences.getInstance();
      // sp.setBool(KEYLOGIN, true);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage(),));

    } on FirebaseAuthException catch (e){
      if(e.code=='user-not-found'){
        print(e.code);
      }
      else if(e.code=='wrong-password'){
        print(e.code);
      }
      else if(e.code=='invalid-email'){
        print(e.code);
      }
      else if(e.code=='user-disabled'){
        print(e.code);
      }
      else
        print(e.code);


    }
    catch(e){
      print(e);
    }
  }

  Future<void> signout(context) async {
    await FirebaseAuth.instance.signOut();
    // SharedPreferences sp = await SharedPreferences.getInstance();
    // sp.setBool(KEYLOGIN, false);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const login(),));
  }




}
