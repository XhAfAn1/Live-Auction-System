import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:liveauctionsystem/app%20datas/theme%20data.dart';
import 'package:liveauctionsystem/wrapper.dart';
//import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase/firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await Supabase.initialize(
  //   url: 'https://kwhmontckigovxyadkrf.supabase.co',   // Replace with your Supabase project URL
  //   anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt3aG1vbnRja2lnb3Z4eWFka3JmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDEwMjQ0NDYsImV4cCI6MjA1NjYwMDQ0Nn0.i_Xq0SEh6BqDZu1s_7Fb_CqHXwFDUiPrKlfnch9t9kQ', // Replace with your Supabase anon key
  // );

 // monitorAuctionStatus();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    //  theme: ThemeData(colorScheme: LightDarkMode.dark),
      home: wrapper(), // Pass initial user to wrapper
    );
  }
}
void monitorAuctionStatus() async{


  Timer.periodic(Duration(seconds: 1), (timer) async{

    QuerySnapshot auctions = await FirebaseFirestore.instance
        .collection('products')
        .where('status', isNotEqualTo: 'ended')
        .get();
    DateTime now = DateTime.now();


    for (var auction in auctions.docs) {
      DateTime endTime = DateTime.parse(auction['auctionEndTime']);

      DateTime startTime = DateTime.parse(auction['auctionStartTime']);


      if(now.isAfter(startTime) && auction['status'] != 'active'){
        print('hi');
        print('${auction['name']} ${auction['status']}');
        await auction.reference.update({'status': 'active'});
      }

      // Check if the auction has ended
      if (now.isAfter(endTime) && auction['status'] != 'ended') {
        await auction.reference.update({'status': 'ended'});

      }


    }
  });
}

