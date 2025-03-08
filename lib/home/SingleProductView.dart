import 'dart:async';
import 'dart:ffi';

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
  TextEditingController bidController=TextEditingController();
   //late int _remainingTime;
 //late Timer _timer;
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    bidController=TextEditingController(text: widget.product.currentPrice.toString());
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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

          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("products")
                .doc(widget.product.productId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text('Product not found.'));
              }

              // Extract Firestore data
              var productData = snapshot.data!.data() as Map<String, dynamic>;
              double newPrice = (productData["currentPrice"] as num).toDouble();

              // Only update the UI if the price has changed
              if (widget.product.currentPrice < newPrice) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    widget.product.currentPrice = newPrice;
                    bidController.text = newPrice.toString();
                  });
                });
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Current Price: \$${newPrice.toStringAsFixed(2)}'),
                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        child: TextField(
                          controller: bidController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: "Enter bid"),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          double? bidAmount = double.tryParse(bidController.text);
                          if (bidAmount == null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text("Invalid bid amount")));
                            return;
                          }

                          widget.product.placeBid(context, bidAmount);
                        },
                        child: Text("Bid"),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ],
              );
            },
          ),



          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .doc(widget.product.productId)
                  .collection("biders")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                else if (snapshot.connectionState == ConnectionState.active){

                  QuerySnapshot data= snapshot.data as QuerySnapshot;
                  var msg=data.docs[0];
                  var bidDocs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: bidDocs.length,
                    itemBuilder: (context, index) {
                      final bidData = bidDocs[index].data() as Map<String, dynamic>;
                      final name = bidData["name"] ?? "No name found";
                      final bidAmount = bidData["bid"] ?? 0.0;

                      return ListTile(
                        title: Text(name, style: const TextStyle(color: Colors.black)),
                        subtitle: Text('\$${bidAmount.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.grey)),
                      );
                    },
                  );
                }

                else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No bidders available.'));
                }
                else
                  return const Center(child: Text('No bidders available.'));


              },
            )
          ),


        ],
      ),
    );
  }

}
