import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../classes/Product.dart';

class Singleproductview extends StatefulWidget {
  final Product product;
  Singleproductview({required this.product,super.key});


  @override
  State<Singleproductview> createState() => _SingleproductviewState();
}

class _SingleproductviewState extends State<Singleproductview> {
 //late int _remainingTime;
 //late Timer _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  // _remainingTime = widget.product.getRemainingTime();
  // _startTimer();
  }

  // void _startTimer() {
  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     setState(() {
  //       _remainingTime = widget.product.getRemainingTime();
  //       if (_remainingTime <= 0) {
  //         _timer.cancel();
  //       }
  //     });
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        centerTitle: true,
      ),
      body: Column(
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
         // Text('Time Remaining: ${widget.product.formatRemainingTime(_remainingTime)}'),
          SizedBox(height: 18),
          ElevatedButton(onPressed: () async{

           // await FirebaseFirestore.instance.collection('products').doc(widget.product.productId).collection("biders").add(<String, dynamic>{"uid":FirebaseAuth.instance.currentUser!.uid, "timestamp": FieldValue.serverTimestamp(),});
            await FirebaseFirestore.instance.collection('products').doc(widget.product.productId).collection("biders").doc(DateTime.timestamp().toString()).set(<String, dynamic>{"uid":FirebaseAuth.instance.currentUser!.uid, "timestamp": FieldValue.serverTimestamp(),});
          }, child: Text("Bid")),
          SizedBox(height: 18),


          Expanded(
            child: StreamBuilder<QuerySnapshot>  (
              stream: FirebaseFirestore.instance.collection('products').doc(widget.product.productId).collection("biders").orderBy("timestamp", descending: true).snapshots(),

              builder: (context, snapshot) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return Center(child: CircularProgressIndicator());
                // }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    title: Text('Loading...', style: TextStyle(color: Colors.black)),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No biders available.'));
                }
                var total=snapshot.data!.docs.length;
                      return ListView.builder(
                        itemCount: total,
                        itemBuilder: (context, index) {
                          final uid=snapshot.data!.docs[index]["uid"];
                          final bider=snapshot.data!.docs[index];

                          return StreamBuilder(stream: FirebaseFirestore.instance.collection('Users').doc(uid).snapshots(), builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              }
                              if (userSnapshot.connectionState == ConnectionState.waiting) {
                                return ListTile(
                                  title: Text('Loading...', style: TextStyle(color: Colors.black)),
                                );
                              }
                              if (!userSnapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return Center(child: Text('No biders available.'));
                              }
                              final userData = userSnapshot.data!.data() ;
                              final email = userData?['email'] ?? 'No email found';
                              final name = userData?['name'] ?? 'No name found';
                              return ListTile(
                                title: Text(email, style: TextStyle(color: Colors.black)),
                                subtitle: Text(uid, style: TextStyle(color: Colors.grey)),
                              );
                          },);
                        },
                      );

              },
            ),
          ),


        ],
      ),
    );
  }

}
