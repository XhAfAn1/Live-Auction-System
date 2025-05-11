import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Product {
  final String productId;
  final String name;
  final String description;
  final int startingPrice;
  int currentPrice;
  final String sellerId;
  final String highBidderId;
  String highBidderName;
  final String sellerName;
  final DateTime auctionStartTime;
  DateTime auctionEndTime;
  final String imageUrl;
  final String? category;
  String status;
  bool paid;
  bool notified;

  Product( {
    required this.productId,
    required this.name,
    required this.description,
    required this.startingPrice,
    required this.currentPrice,
    required this.sellerId,
    required this.sellerName,
    required this.highBidderId,
    required this.highBidderName,
    required this.auctionStartTime,
    required this.auctionEndTime,
    required this.imageUrl,
    this.category,
    this.status = 'active',
    this.paid = false,
    this.notified = false
  });

  // Method to place a bid
  Future<void> placeBid(context,int bidPrice,String status) async {
    if(bidPrice>currentPrice && status=='active'){
      try {
        String userId = FirebaseAuth.instance.currentUser!.uid;

        // Fetch user details first (asynchronously)
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("Users")
            .doc(userId)
            .get();

        if (!userDoc.exists || !userDoc.data().toString().contains('name')) {
          throw Exception("User data not found");
        }

        String userName = userDoc.get("name"); // Fetch user's name


        // Save bid details in Firestore
        //await
       await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .collection("biders")
            .doc(DateTime.now().toString()) // Unique ID
            .set({
          "uid": userId,
          "name": userName,
          "timestamp": FieldValue.serverTimestamp(),
          "bid": bidPrice
        });
        await
        FirebaseFirestore.instance
            .collection('products')
            .doc(productId).update({"currentPrice":bidPrice,"highBidderName":userName,"highBidderId":userId});

        // FirebaseFirestore.instance
        //     .collection('products')
        //     .doc(productId).update({"highBidderName":userName,"highBidderId":userId});

        currentPrice=bidPrice;

        print("Bid placed successfully!");
      } catch (e) {
        print("Error placing bid: $e");
      }
    }
    else if(bidPrice<=currentPrice && status=='active'){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bid Price must be higher")));
    }
    else if(status=='ended'){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Auction has ended")));
    }
  }

  Future<void> placePrivateBid(context,int bidPrice,String status,String roomId) async {
    if(bidPrice>currentPrice && status=='active'){
      try {
        String userId = FirebaseAuth.instance.currentUser!.uid;

        // Fetch user details first (asynchronously)
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("Users")
            .doc(userId)
            .get();

        if (!userDoc.exists || !userDoc.data().toString().contains('name')) {
          throw Exception("User data not found");
        }

        String userName = userDoc.get("name"); // Fetch user's name


        // Save bid details in Firestore
        await FirebaseFirestore.instance
            .collection('private rooms')
            .doc(roomId)
            .collection("products")
            .doc(productId)
            .collection("biders")
            .doc(DateTime.now().toString()) // Unique ID
            .set({
          "uid": userId,
          "name": userName,
          "timestamp": FieldValue.serverTimestamp(),
          "bid": bidPrice
        });
        await
        FirebaseFirestore.instance
            .collection('private rooms')
            .doc(roomId)
            .collection("products")
            .doc(productId).update({"currentPrice":bidPrice,"highBidderName":userName,"highBidderId":userId});

        // FirebaseFirestore.instance
        //     .collection('products')
        //     .doc(productId).update({"highBidderName":userName,"highBidderId":userId});

        currentPrice=bidPrice;

        print("Bid placed successfully!");
      } catch (e) {
        print("Error placing bid: $e");
      }
    }
    else if(bidPrice<=currentPrice && status=='active'){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bid Price must be higher")));
    }
    else if(status=='ended'){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Auction has ended")));
    }
  }
  // Method to update the status of the auction
  void updateStatus() {
    final now = DateTime.now();
    if (now.isAfter(auctionEndTime)) {
      status = 'ended';
    }
  }

  int? getTimeRemaining() {
    final now = DateTime.now();
    if (now.isBefore(auctionEndTime)) {
      return auctionEndTime.difference(now).inSeconds;
    }
    return null;
  }

  int getRemainingTime() {
   // auctionEndTime = FirebaseFirestore
    final now = DateTime.now();
    return auctionEndTime.difference(now).inSeconds;
  }

  // Format remaining time as HH:MM:SS
  String formatRemainingTime(int seconds) {
    if (seconds <= 0) {
      return '00\h 00\m 00\s';
    }
    final days = (seconds ~/ 86400).toString().padLeft(2, '0'); // Calculate days
    final hours = ((seconds % 86400) ~/ 3600).toString().padLeft(2, '0'); // Hours without counting extra days
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0'); // Minutes
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0'); // Seconds
    return '$days\d $hours\h $minutes\m $remainingSeconds\s';
  }

  // Convert the product to a map (useful for Firebase or other databases)
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'description': description,
      'startingPrice': startingPrice,
      'currentPrice': currentPrice,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'highBidderId': highBidderId,
      'highBidderName': highBidderName,
      'auctionStartTime': auctionStartTime.toIso8601String(),
      'auctionEndTime': auctionEndTime.toIso8601String(),
      'imageUrl': imageUrl,
      'category': category,
      'status': status,
      'paid': paid,
      'notified': notified
    };
  }

  // Create a Product object from a map (useful for Firebase or other databases)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productId: map['productId'],
      name: map['name'],
      description: map['description'],
      startingPrice: map['startingPrice'],
      currentPrice: map['currentPrice'],
      sellerId: map['sellerId'],
      sellerName: map['sellerName'],
      highBidderName: map['highBidderName'],
      highBidderId: map['highBidderId'],
      auctionStartTime: DateTime.parse(map['auctionStartTime']),
      auctionEndTime: DateTime.parse(map['auctionEndTime']),
      imageUrl: map['imageUrl'],
      category: map['category'],
      status: map['status'],
      paid: map['paid'],
      notified: map['notified'],
    );
  }
  // Convert Firestore document to Product object
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      productId: doc.id,
      name: data['name'],
      description: data['description'],
      startingPrice: data['startingPrice'],
      currentPrice: data['currentPrice'],
      sellerId: data['sellerId'],
      sellerName: data['sellerName'],
      highBidderName: data['highBidderName'],
      highBidderId: data['highBidderId'],
      auctionStartTime: DateTime.parse(data['auctionStartTime']),
      auctionEndTime: DateTime.parse(data['auctionEndTime']),
      imageUrl: data['imageUrl'],
      category: data['category'],
      status: data['status'],
      paid: data['paid'],
      notified: data['notified'],
    );
  }


  @override
  String toString() {
    return 'Product(productId: $productId, name: $name, currentPrice: $currentPrice, status: $status)';
  }
}