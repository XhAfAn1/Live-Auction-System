import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../home/homepage.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();

  String path = "";
  String url = "";
  String btnText = "Add Product";
  File? image;
  bool isUploading = false;
  String _imageUrl = '';
  String _stats = '';
  String _sellerId = FirebaseAuth.instance.currentUser!.uid;
  String highBidderId = "";
  String highBidderName = "";
  DateTime _auctionStartTime = DateTime.now();
  DateTime _auctionEndTime = DateTime.now().add(Duration(days: 7));

  Future<void> getImage(ImageSource source) async {
    try {
      final pic = await ImagePicker().pickImage(source: source);
      if (pic != null) {
        setState(() {
          image = File(pic.path);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> download() async {
    try {
      path = 'itemPhoto/${DateTime.now().millisecondsSinceEpoch}.jpeg';
      final ref = FirebaseStorage.instance.ref(path);
      await ref.putFile(image!);
      url = await ref.getDownloadURL();
      setState(() {
        _imageUrl = url;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartTime) async {
    final DateTime initialDate = isStartTime ? _auctionStartTime : _auctionEndTime;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      _selectTime(context, isStartTime, pickedDate, initialDate);
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime, DateTime pickedDate, DateTime initialDate) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );
    if (pickedTime != null) {
      final combinedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      setState(() {
        if (isStartTime) {
          _auctionStartTime = combinedDateTime;
        } else {
          _auctionEndTime = combinedDateTime;
        }
      });
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select an image.')));
      return;
    }

    setState(() => isUploading = true);

    try {
      await download();
      final sellerSnapshot = await FirebaseFirestore.instance.collection("Users").doc(_sellerId).get();
      final sellerName = sellerSnapshot.get("name");

      final now = DateTime.now();
      if (_auctionStartTime.isAfter(now)) {
        _stats = "upcoming";
      } else if (_auctionEndTime.isAfter(now)) {
        _stats = "active";
      } else {
        _stats = "ended";
      }

      final productData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'startingPrice': int.parse(_priceController.text),
        'currentPrice': int.parse(_priceController.text),
        'sellerId': _sellerId,
        'highBidderId': highBidderId,
        'highBidderName': highBidderName,
        'sellerName': sellerName,
        'auctionStartTime': _auctionStartTime.toIso8601String(),
        'auctionEndTime': _auctionEndTime.toIso8601String(),
        'imageUrl': _imageUrl,
        'category': _categoryController.text,
        'status': _stats,
        'paid': false,
        'notified':false
      };

      await _firestore.collection('request').doc(DateTime.now().toString()).set(productData);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product added successfully!')));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add product.')));
    } finally {
      setState(() => isUploading = false);
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
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a product name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Starting Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a starting price';
                  if (int.tryParse(value) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              if (image != null) Image.file(image!),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => getImage(ImageSource.gallery),
                    child: Text("Select Photo"),
                  ),
                  IconButton(
                    onPressed: () => getImage(ImageSource.camera),
                    icon: Icon(Icons.add_a_photo_outlined),
                  ),
                ],
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              SizedBox(height: 16),
              Text('Auction Start Time: ${DateFormat('yyyy-MM-dd – HH:mm').format(_auctionStartTime)}'),
              ElevatedButton(
                onPressed: () => _selectDate(context, true),
                child: Text('Select Start Date'),
              ),
              SizedBox(height: 16),
              Text('Auction End Time: ${DateFormat('yyyy-MM-dd – HH:mm').format(_auctionEndTime)}'),
              ElevatedButton(
                onPressed: () => _selectDate(context, false),
                child: Text('Select End Date'),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: isUploading ? null : () => _submitForm(context),
                child: isUploading ? CircularProgressIndicator(color: Colors.white) : Text(btnText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}