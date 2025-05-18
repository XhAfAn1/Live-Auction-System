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

  // Theme colors
  final Color primaryColor = Color(0xff093125);
  final Color accentColor = Color(0xffA8ED4F);

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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      _selectTime(context, isStartTime, pickedDate, initialDate);
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime, DateTime pickedDate, DateTime initialDate) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select an image.'),
            backgroundColor: primaryColor,
          )
      );
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
        'notified': false
      };

      await _firestore.collection('request').doc(DateTime.now().toString()).set(productData);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product added successfully!'),
          )
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add product.'),
            backgroundColor: Colors.red,
          )
      );
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
        elevation: 0,
        title: Text(
          'Add Product',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
       // iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Upload Section
                  Center(
                    child: GestureDetector(
                      onTap: () => getImage(ImageSource.gallery),
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: image != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            image!,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 50,
                              color: primaryColor,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Add Product Image',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Image Source Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.photo_library, size: 18),
                          label: Text("Gallery"),
                          onPressed: () => getImage(ImageSource.gallery),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton.icon(
                          icon: Icon(Icons.camera_alt, size: 18),
                          label: Text("Camera"),
                          onPressed: () => getImage(ImageSource.camera),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: primaryColor,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Product Details Section
                  Text(
                    'Product Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Form Fields
                  _buildTextField(
                    controller: _nameController,
                    label: 'Product Name',
                    hint: 'Enter product name',
                    icon: Icons.shopping_bag_outlined,
                    validator: (value) => value == null || value.isEmpty ? 'Please enter a product name' : null,
                  ),

                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    hint: 'Enter product description',
                    icon: Icons.description_outlined,
                    maxLines: 3,
                    validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
                  ),

                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _priceController,
                    label: 'Starting Price',
                    hint: 'Enter starting price',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter a starting price';
                      if (int.tryParse(value) == null) return 'Enter a valid number';
                      return null;
                    },
                  ),

                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _categoryController,
                    label: 'Category',
                    hint: 'Enter product category',
                    icon: Icons.category_outlined,
                  ),

                  SizedBox(height: 24),

                  // Auction Time Section
                  Text(
                    'Auction Schedule',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Start Time
                  _buildDateTimeSelector(
                    title: 'Start Time',
                    dateTime: _auctionStartTime,
                    onTap: () => _selectDate(context, true),
                    icon: Icons.event_available,
                  ),

                  SizedBox(height: 16),

                  // End Time
                  _buildDateTimeSelector(
                    title: 'End Time',
                    dateTime: _auctionEndTime,
                    onTap: () => _selectDate(context, false),
                    icon: Icons.event_busy,
                  ),

                  SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isUploading ? null : () => _submitForm(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: primaryColor.withOpacity(0.5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: isUploading
                          ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        btnText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build consistent text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  // Helper method to build date/time selectors
  Widget _buildDateTimeSelector({
    required String title,
    required DateTime dateTime,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[50],
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryColor),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  DateFormat('yyyy-MM-dd – HH:mm').format(dateTime),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}