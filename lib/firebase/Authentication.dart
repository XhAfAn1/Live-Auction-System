import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveauctionsystem/adminPanel/admin_panel.dart';
import 'package:liveauctionsystem/classes/user.dart';
import 'package:liveauctionsystem/home/profile.dart';

import '../home/homepage.dart';
import '../login signup/login.dart';

class Authentication {




  Future<bool> signin(
      {required String email, required String password,context}) async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      User? user = FirebaseAuth.instance.currentUser;
      print("success");
      print(FirebaseAuth.instance.currentUser);
      final data=await FirebaseFirestore.instance.collection("Users").doc(user!.uid).get();
      UserModel cuser=UserModel.fromJson((data).data()!);
      await Future.delayed(Duration(seconds: 1));

      if(cuser.admin==true)
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => admin_panel()), (Route<dynamic> route) => false,);
      else
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage(),));

    } on FirebaseAuthException catch (e){
      if(e.code=='user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text( e.code.toString())) );
        return false;
      }
      else if(e.code=='wrong-password'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text( e.code.toString())) );
        return false;
      }
      else if(e.code=='invalid-email'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text( e.code.toString())) );
        return false;
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text( e.code.toString())) );
        return false;
      }



    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text( e.toString())) );
      return false;
    }
    return true;
  }

  Future<void> signout(context) async {
    await FirebaseAuth.instance.signOut();

    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const login(),));
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const HomePage(),));
  }




}
