import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
//import 'package:supabase_flutter/supabase_flutter.dart';

import '../home/homepage.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  File? image;
  String path="";
  String url="";
  String btn_test="Add Product";

  getImage() async{
    var pic=await ImagePicker().pickImage(source: ImageSource.gallery);

    if(kIsWeb){

      setState(() {
        image=File(pic!.path);
      });
    }
    else{
      setState(() {
        image=File(pic!.path);
      });
    }
  //  download();

  }
  download() async{
    try {
      print("1");
      //path=DateTime.now().toString();
      path = 'itemPhoto/${DateTime
          .now()
          .millisecondsSinceEpoch}.jpeg';
      print("2");
      await FirebaseStorage.instance.ref(path).putFile(image!);
      print("3");
      url = await FirebaseStorage.instance.ref(path).getDownloadURL();
      print("4");
      print(url);
      setState(() {
        _imageUrl = url;
      });
    }catch(e){
      print(e);
    }
  }


  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  // Form fields
  String _name = '';
  String _description = '';
  int _startingPrice = 0;
  String _sellerId =   FirebaseAuth.instance.currentUser!.uid;
  String highBidderId =   "";
  String highBidderName =   "";
  DateTime _auctionStartTime = DateTime.now();
  DateTime _auctionEndTime = DateTime.now().add(Duration(days: 7));
  String _imageUrl = '';
  String _category = '';
  String _stats='';


   _selectDate(BuildContext context, bool isStartTime) async {

    final DateTime initialDate = isStartTime ? _auctionStartTime : _auctionEndTime;


    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      _selectTime(context, isStartTime,pickedDate,initialDate);
    }
    print(_auctionStartTime);
  }
  _selectTime(BuildContext context, bool isStartTime,DateTime pickedDate,DateTime initialDate ) async{

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (pickedTime != null) {

      final DateTime combinedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      if (isStartTime) {
        setState(() {
          _auctionStartTime = combinedDateTime;
        });

      } else {
        setState(() {
          _auctionEndTime = combinedDateTime;
        });

      }

    }
  }



  // Submit form
  void _submitForm(context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    //  await upload();
      await download();
      String sellerName =  await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) => value.get("name"));


      if(_auctionStartTime.isAfter(DateTime.now()))
        _stats="upcoming";
      else if(_auctionStartTime.isBefore(DateTime.now()) || _auctionEndTime.isAtSameMomentAs(DateTime.now()))
        _stats="active";

      // Create a new product map
      final productData = {
        'name': _name,
        'description': _description,
        'startingPrice': _startingPrice,
        'currentPrice': _startingPrice, // Initially, current price = starting price
        'sellerId': _sellerId,
        'highBidderId': highBidderId,
        'highBidderName': highBidderName,
        'sellerName': sellerName,
        'auctionStartTime': _auctionStartTime.toIso8601String(),
        'auctionEndTime': _auctionEndTime.toIso8601String(),
        'imageUrl': _imageUrl,
        'category': _category,
        'status': _stats,
      };
      print("1");
      // Add product to Firestore
    //  await _firestore.collection('products').add(productData);
      await _firestore.collection('products').doc(DateTime.now().toString()).set(productData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully!')),
      );

      // Clear the form
      _formKey.currentState!.reset();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
    }
    else{
      Timer(Duration(milliseconds: 50), () {
        setState(() {
          btn_test="Add Product";
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Starting Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a starting price';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => _startingPrice = int.parse(value!),
              ),



           image!=null ? Container(child: Image.file(image!),) : Container(),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Image URL'),
              //   onSaved: (value) => _imageUrl = value!,
              // ),
              ElevatedButton(onPressed: (){
                getImage();

              }, child: Text("select photo")),
              // ElevatedButton(onPressed: (){
              //   download();
              // }, child: Text("upload")),
              // ElevatedButton(onPressed: () {
              //   download();
              // },child: Text("download"),),
              TextFormField(
                decoration: InputDecoration(labelText: 'Category'),
                onSaved: (value) => _category = value!,
              ),
              SizedBox(height: 16),
              Text('Auction Start Time: ${DateFormat('yyyy-MM-dd').format(_auctionStartTime)}- ${DateFormat('HH:mm').format(_auctionStartTime)}'),
              ElevatedButton(
                onPressed: () => _selectDate(context, true),
                child: Text('Select Start Date'),
              ),
              SizedBox(height: 16),
              Text('Auction End Time: ${DateFormat('yyyy-MM-dd').format(_auctionEndTime)}- ${DateFormat('HH:mm').format(_auctionEndTime)}'),
              ElevatedButton(
                onPressed: () => _selectDate(context, false),
                child: Text('Select End Date'),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: (){
                  setState(() {
                    btn_test="Uploading...";
                  });
                  _submitForm(context);
                },
                child: Text(btn_test),
              ),
            ],
          ),
        ),
      ),
    );
  }
}