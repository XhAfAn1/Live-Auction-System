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
  TextEditingController bidController=TextEditingController();

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    bidController=TextEditingController(text: (widget.product.currentPrice+1).toString());
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.product.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            if (widget.product.imageUrl != null)
              Image.network(widget.product.imageUrl!, height: 150, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 8),
            Text(widget.product.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(widget.product.description),
            // ElevatedButton(onPressed: (){
            //   showDiag(context,widget.product.highBidderName,widget.product.currentPrice.toString());
            // }, child: Text("test_btn")),
            SizedBox(height: 8),
            timer(product: widget.product),
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
                    widget.product.currentPrice = newPrice;
                    bidController.text = (newPrice+1).toString();
                    // setState(() {
                    //
                    // });
                  });
                }


                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  //  Text("Remaining Time: ${_remainingTime ~/ 3600}h ${(_remainingTime % 3600) ~/ 60}m ${_remainingTime % 60}s"),
                    Text('Current Price: \$${newPrice.toStringAsFixed(2)}'),
                    SizedBox(height: 8),
                    Text('Top Bidder: ${productData["highBidderName"]}'),
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

                            widget.product.placeBid(context, bidAmount, widget.product.status);
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



            StreamBuilder<QuerySnapshot>(
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
                else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Padding(
                      padding: EdgeInsets.all(100.0),
                      child: Text('No bidders available.')));
                }
                else if (snapshot.connectionState == ConnectionState.active){

                  QuerySnapshot data= snapshot.data as QuerySnapshot;
                  var msg=data.docs[0];
                  var bidDocs = snapshot.data!.docs;

                         //status update test
                  statuscheck(widget.product.productId,context);

                  

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bidDocs.length,
                    itemBuilder: (context, index) {
                      var bidData = bidDocs[index].data() as Map<String, dynamic>;
                      final name = bidData["name"] ?? "No name found";
                      var email = bidData["email"] ?? "No email found";


                      final bidAmount = bidData["bid"] ?? 0.0;


                      
                      


                      return ListTile(
                        title: Text('$name:  $email', style: const TextStyle(color: Colors.black)),
                        subtitle: Text('\$${bidAmount.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.grey)),
                      );
                    },
                  );
                }


                else
                  return const Center(child: Text('No bidders available.'));


              },
            ),


          ],
        ),
      ),
    );
  }


  statuscheck(String id, BuildContext context) {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      try {
        DateTime now = DateTime.now();
        DocumentSnapshot auction = await FirebaseFirestore.instance
            .collection('products')
            .doc(id)
            .get();


        DateTime endTime = DateTime.parse(auction['auctionEndTime']);


        if (now.isAfter(endTime) && auction['status'] != 'ended') {
          await auction.reference.update({'status': 'ended'});
          print('Auction ${auction.id} has ended.');

          setState(() {
            widget.product.status='ended';
          });

          showDiag(context,widget.product.highBidderName,widget.product.currentPrice.toString());

          timer.cancel();
        }
      } catch (e) {
        print('Error in statusCheck: $e');
        timer.cancel();
      }
    });
  }

  showDiag(context,String name,String price){
    showDialog(context: context,
      builder: (context) =>
          AlertDialog(
            title: Text(
              'Sold to ${name} at \$${price}',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          ),
    );



  }
}

class timer extends StatefulWidget {
  final Product product;
  const timer({super.key, required this.product});

  @override
  State<timer> createState() => _timerState();
}

class _timerState extends State<timer> {
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
    return Column(
      children: [
        Text('Time Remaining: ${widget.product.formatRemainingTime(
            _remainingTime)}', style: TextStyle(fontWeight: FontWeight.w700),)

      ],
    );
  }


}
