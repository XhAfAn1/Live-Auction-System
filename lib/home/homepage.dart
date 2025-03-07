import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liveauctionsystem/adminPanel/add_product.dart';

import '../classes/Product.dart';
import '../firebase/Authentication.dart';
import 'SingleProductView.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auction Products'),
        actions: [

      Container(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser?.uid) // Use the logged-in user's ID
              .get(),

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[300],
                child: CircularProgressIndicator(), // Show a loading indicator
              );
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 30, color: Colors.white), // Default icon
              );
            }

            // Fetch profile image URL from Firestore
            String? imageUrl = snapshot.data!.get("profileImageUrl"); // Ensure field exists

            return CircleAvatar(
              radius: 30,
              backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                  ? NetworkImage(imageUrl)
                  : null,
              backgroundColor: Colors.grey[300],
              child: (imageUrl == null || imageUrl.isEmpty)
                  ? Icon(Icons.person, size: 30, color: Colors.white)
                  : null,
            );
          },
        ),
      ),

          Container(
            width: 20,
          )
        ],
      ),
      body:Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('products').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
            
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No products available.'));
                }
            
                final products = snapshot.data!.docs.map((doc) => Product.fromFirestore(doc)).toList();
            
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(product: product);
                  },
                );
              },
            ),
          ),
          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductForm(),));
          }, child: Text("Add Product")),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: () {
            Authentication().signout(context);
          }, child: Text("Logout")),
          SizedBox(height: 20,)

        ],
      )
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late int _remainingTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.product.getRemainingTime();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime = widget.product.getRemainingTime();
        if (_remainingTime <= 0) {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Singleproductview(product: widget.product),));
      },
      child: Card(
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.product.imageUrl != null)
                Image.network(widget.product.imageUrl!, height: 150, width: double.infinity, fit: BoxFit.cover),
              SizedBox(height: 8),
              Text(widget.product.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(widget.product.description),
              SizedBox(height: 8),
              Text('Starting Price: \$${widget.product.startingPrice.toStringAsFixed(2)}'),
              SizedBox(height: 8),
              Text('Current Price: \$${widget.product.currentPrice.toStringAsFixed(2)}'),
              SizedBox(height: 8),
              Text('Time Remaining: ${widget.product.formatRemainingTime(_remainingTime)}'),
            ],
          ),
        ),
      ),
    );
  }
}
// ElevatedButton(onPressed: (){
// Authentication().signout(context);
// }, child: Text("Logout")),
// SizedBox(height: 20,)