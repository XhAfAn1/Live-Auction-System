import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  File? image;
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
              TextFormField(
                decoration: InputDecoration(
                  label: Text("Username"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: "Enter Username",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Starting Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a starting price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              image!=null ? Container(child: Image.file(image!),) : Container(),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Image URL'),
              //   onSaved: (value) => _imageUrl = value!,
              // ),
              ElevatedButton(onPressed: (){
              //  getImage();
              }, child: Text("select photo")),
              // ElevatedButton(onPressed: (){
              //   upload();
              // }, child: Text("upload")),
              // ElevatedButton(onPressed: () {
              //   download();
              // },child: Text("download"),),
              TextFormField(
                decoration: InputDecoration(labelText: 'Category'),

              ),
              SizedBox(height: 16),
              // Text('Auction Start Time: ${DateFormat('yyyy-MM-dd').format(_auctionStartTime)}'),
              // ElevatedButton(
              //   onPressed: () => _selectDate(context, true),
              //   child: Text('Select Start Date'),
              // ),
              // SizedBox(height: 16),
              // Text('Auction End Time: ${DateFormat('yyyy-MM-dd').format(_auctionEndTime)}'),
              // ElevatedButton(
              //   onPressed: () => _selectDate(context, false),
              //   child: Text('Select End Date'),
              // ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: (){

                },
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      )
    );
  }
}
