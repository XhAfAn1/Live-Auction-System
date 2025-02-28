import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class AddProductForm extends StatefulWidget {
  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  // Form fields
  String _name = '';
  String _description = '';
  double _startingPrice = 0.0;
  String _sellerId = 'seller123'; // Replace with actual seller ID
  DateTime _auctionStartTime = DateTime.now();
  DateTime _auctionEndTime = DateTime.now().add(Duration(days: 7));
  String _imageUrl = '';
  String _category = '';

  // Date picker for auction start and end times
  Future<void> _selectDate(BuildContext context, bool isStartTime) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartTime ? _auctionStartTime : _auctionEndTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _auctionStartTime = picked;
        } else {
          _auctionEndTime = picked;
        }
      });
    }
  }

  // Submit form
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a new product map
      final productData = {
        'name': _name,
        'description': _description,
        'startingPrice': _startingPrice,
        'currentPrice': _startingPrice, // Initially, current price = starting price
        'sellerId': _sellerId,
        'auctionStartTime': _auctionStartTime.toIso8601String(),
        'auctionEndTime': _auctionEndTime.toIso8601String(),
        'imageUrl': _imageUrl,
        'category': _category,
        'status': 'active',
      };

      // Add product to Firestore
      await _firestore.collection('products').add(productData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully!')),
      );

      // Clear the form
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => _startingPrice = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Image URL'),
                onSaved: (value) => _imageUrl = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Category'),
                onSaved: (value) => _category = value!,
              ),
              SizedBox(height: 16),
              Text('Auction Start Time: ${DateFormat('yyyy-MM-dd').format(_auctionStartTime)}'),
              ElevatedButton(
                onPressed: () => _selectDate(context, true),
                child: Text('Select Start Date'),
              ),
              SizedBox(height: 16),
              Text('Auction End Time: ${DateFormat('yyyy-MM-dd').format(_auctionEndTime)}'),
              ElevatedButton(
                onPressed: () => _selectDate(context, false),
                child: Text('Select End Date'),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}