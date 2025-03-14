import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:liveauctionsystem/wrapper.dart';
import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

 // monitorAuctionStatus();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: wrapper(), // Pass initial user to wrapper
    );
  }
}
void monitorAuctionStatus() async{
  // Fetch active auctions
  QuerySnapshot auctions = await FirebaseFirestore.instance
      .collection('products')
      .where('status', isEqualTo: 'active')
      .get();
  Timer.periodic(Duration(seconds: 1), (timer) async{
    // Get current time
    DateTime now = DateTime.now();

    for (var auction in auctions.docs) {
      DateTime endTime = DateTime.parse(auction['auctionEndTime']);

      // Check if the auction has ended
      if (now.isAfter(endTime)) {
        await auction.reference.update({'status': 'ended'});
        print('Auction ${auction.id} has ended.');
      }
    }
  });
}

