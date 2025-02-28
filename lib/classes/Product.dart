import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String productId;
  final String name;
  final String description;
  final double startingPrice;
  double currentPrice;
  final String sellerId;
  final DateTime auctionStartTime;
  final DateTime auctionEndTime;
  final String? imageUrl;
  final String? category;
  String status;

  Product({
    required this.productId,
    required this.name,
    required this.description,
    required this.startingPrice,
    required this.currentPrice,
    required this.sellerId,
    required this.auctionStartTime,
    required this.auctionEndTime,
    this.imageUrl,
    this.category,
    this.status = 'active',
  });

  // Method to place a bid
  bool placeBid(double bidAmount) {
    if (bidAmount > currentPrice && status == 'active') {
      currentPrice = bidAmount;
      return true;
    }
    return false;
  }

  // Method to update the status of the auction
  void updateStatus() {
    final now = DateTime.now();
    if (now.isAfter(auctionEndTime)) {
      status = 'ended';
    }
  }

  // Method to get the remaining time in seconds
  int? getTimeRemaining() {
    final now = DateTime.now();
    if (now.isBefore(auctionEndTime)) {
      return auctionEndTime.difference(now).inSeconds;
    }
    return null;
  }
  int getRemainingTime() {
    final now = DateTime.now();
    return auctionEndTime.difference(now).inSeconds;
  }

  // Format remaining time as HH:MM:SS
  String formatRemainingTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$remainingSeconds';
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
      'auctionStartTime': auctionStartTime.toIso8601String(),
      'auctionEndTime': auctionEndTime.toIso8601String(),
      'imageUrl': imageUrl,
      'category': category,
      'status': status,
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
      auctionStartTime: DateTime.parse(map['auctionStartTime']),
      auctionEndTime: DateTime.parse(map['auctionEndTime']),
      imageUrl: map['imageUrl'],
      category: map['category'],
      status: map['status'],
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
      auctionStartTime: DateTime.parse(data['auctionStartTime']),
      auctionEndTime: DateTime.parse(data['auctionEndTime']),
      imageUrl: data['imageUrl'],
      category: data['category'],
      status: data['status'],
    );
  }


  @override
  String toString() {
    return 'Product(productId: $productId, name: $name, currentPrice: $currentPrice, status: $status)';
  }
}