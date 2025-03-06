import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  File? image;

  getImage()async{
    var pic=await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      image=File(pic!.path);
    });
  }

  createAccount() async{


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: ListView(
            children: [
           Align(
             alignment: Alignment.center,
             child: Stack(
               alignment: Alignment.bottomRight,
               children: [
                 CircleAvatar(radius: 60,backgroundImage: image!=null  ?  FileImage(image!) : null,
                   child: image == null ? Icon(Icons.person, size: 60) : null,),

                 Container(
                   height:40,
                   width: 40,
                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.blue),

                   child: IconButton(
                     onPressed: (){
                       getImage();
                     },icon: Icon(Icons.add_a_photo_outlined,),color: Colors.white,),
                 ),

               ],
             ),
           ),

              SizedBox(height: 16),TextFormField(
                decoration: InputDecoration(
                  label: Text("Name"),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: "Enter Name",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.5), // Default border color
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0), // Border color when focused
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.5), // Border color when error occurs
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), TextFormField(
                decoration: InputDecoration(
                  label: Text("Email"),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: "Enter Email Address",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.5), // Default border color
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0), // Border color when focused
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.5), // Border color when error occurs
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a email address';
                  }
                  return null;
                },
              ),
              // SizedBox(height: 16), TextFormField(
              //   decoration: InputDecoration(
              //     label: Text("phone Number"),
              //     border: OutlineInputBorder(
              //         borderSide: BorderSide(color: Colors.grey, width: 1.5),
              //         borderRadius: BorderRadius.all(Radius.circular(10))),
              //     hintText: "Enter phone Number",
              //     enabledBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.grey, width: 1.5), // Default border color
              //       borderRadius: BorderRadius.all(Radius.circular(10)),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.blue, width: 2.0), // Border color when focused
              //       borderRadius: BorderRadius.all(Radius.circular(10)),
              //     ),
              //     errorBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.red, width: 1.5), // Border color when error occurs
              //       borderRadius: BorderRadius.all(Radius.circular(10)),
              //     ),
              //   ),
              //   keyboardType: TextInputType.number,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter a phone number';
              //     }
              //     if (double.tryParse(value) == null) {
              //       return 'Please enter a valid number';
              //     }
              //     return null;
              //   },
              // ),
              SizedBox(height: 16),TextFormField(
                decoration: InputDecoration(
                  label: Text("Password"),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: "Enter Password",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.5), // Default border color
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0), // Border color when focused
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.5), // Border color when error occurs
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },

              ),


              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: (){
                createAccount();
                },
                child: Text("Sign Up",style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      )
    );
  }


}
