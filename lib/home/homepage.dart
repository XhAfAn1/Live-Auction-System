import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liveauctionsystem/adminPanel/add_product.dart';
import 'package:liveauctionsystem/home/profile.dart';

import '../classes/Product.dart';
import '../firebase/Authentication.dart';
import '../main.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Auction Products'),
        actions: [

      Container(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .get(),

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[300],
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => profile(uid: FirebaseAuth.instance.currentUser!.uid,),));
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 30, color: Colors.white),
                ),
              );
            }

            String? imageUrl = snapshot.data!.get("profileImageUrl");

            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => profile(uid: FirebaseAuth.instance.currentUser!.uid,),));
              },
              child: CircleAvatar(
                radius: 30,
                backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                    ? NetworkImage(imageUrl)
                    : null,
                backgroundColor: Colors.grey[300],
                child: (imageUrl == null || imageUrl.isEmpty)
                    ? Icon(Icons.person, size: 30, color: Colors.white)
                    : null,
              ),
            );
          },
        ),
      ),
          SizedBox(width: 10,),
          IconButton(onPressed: (){
            Authentication().signout(context);
          }, icon: Icon(Icons.logout)),
          SizedBox(height: 20,),

          Container(
            width: 20,
          )
        ],
      ),

      floatingActionButton:ElevatedButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductForm(),));
      }, child: Text("Add Product")) ,

      body:Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              
              //stream: _firestore.collection('products').where("status",isEqualTo: "active").orderBy("auctionEndTime",descending: false).snapshots(),
              stream: _firestore.collection('products').orderBy("auctionEndTime",descending: false).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No products available.'));
                }
                final products = snapshot.data!.docs.map((doc) => Product.fromFirestore(doc)).toList();





                monitorAuctionStatus();


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
        color: Colors.white70,
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
              Text(widget.product.description,style: TextStyle(fontWeight: FontWeight.w600),maxLines: 2,overflow: TextOverflow.ellipsis,),
              SizedBox(height: 8),
              Text("Owner: ${widget.product.sellerName}"),
              SizedBox(height: 8),
              Text('Starting Price: \$${widget.product.startingPrice.toStringAsFixed(2)}'),
              SizedBox(height: 8),
              Text('Current Price: \$${widget.product.currentPrice.toStringAsFixed(2)}'),
              SizedBox(height: 8),
              Text('Status: ${widget.product.status}'),
              SizedBox(height: 8),
              Text('Time Remaining: ${widget.product.formatRemainingTime(_remainingTime)}'),
            ],
          ),
        ),
      ),
    );
  }
}
