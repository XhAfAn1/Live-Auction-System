import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../classes/Product.dart';
import '../login signup/login.dart';

class Singleproductview extends StatefulWidget {
  final Product product;
  Singleproductview({required this.product,super.key});


  @override
  State<Singleproductview> createState() => _SingleproductviewState();
}

class _SingleproductviewState extends State<Singleproductview> {
  TextEditingController bidController=TextEditingController();
   Timer? _timer;
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    bidController=TextEditingController(text: (widget.product.currentPrice+1).toString());
  }
  @override
  void dispose() {
    // TODO: implement dispose

    _timer?.cancel();
    super.dispose();
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
            Text('Starting Price: \৳${widget.product.startingPrice.toStringAsFixed(2)}'),
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
                widget.product.highBidderName=productData["highBidderName"];
                int newPrice = (productData["currentPrice"] as num).toInt();

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
                    Text('Current Price: \৳${newPrice.toStringAsFixed(2)}'),
                    SizedBox(height: 8),
                    Text('Top Bidder: ${productData["highBidderName"]}'),
                    Text('Status: ${widget.product.status}'),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if(widget.product.auctionStartTime.isBefore(DateTime.now()))
                        Container(
                          width: 100,
                          child: TextField(
                            controller: bidController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(hintText: "Enter bid"),
                          ),
                        ),
                        SizedBox(width: 10),
                        if(widget.product.auctionStartTime.isBefore(DateTime.now()))
                        ElevatedButton(
                          onPressed: () async {



                            int? bidAmount = int.tryParse(bidController.text);
                            if (bidAmount == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text("Invalid bid amount")));
                              return;
                            }
                            if(FirebaseAuth.instance.currentUser == null){
                              showLogDiag();
                              return;
                            }
                            widget.product.placeBid(context, bidAmount, widget.product.status);
                            // widget.product.auctionEndTime=  widget.product.auctionEndTime.add(Duration(minutes: 5));
                            // print( widget.product.auctionEndTime);
                            // await FirebaseFirestore.instance.collection("products").doc(widget.product.productId).update({"auctionEndTime":widget.product.auctionEndTime.toIso8601String()});
                            //
                            _timer?.cancel();
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

                  _timer?.cancel();
                  statuscheck(widget.product.productId,context);



                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bidDocs.length,
                    itemBuilder: (context, index) {
                      var bidData = bidDocs[index].data() as Map<String, dynamic>;
                      final name = bidData["name"] ?? "No name found";
                      var email = bidData["email"] ?? "No email found";
                      final bidAmount = bidData["bid"] ?? 0;

                      email=func(email,bidData,index);



                      return FutureBuilder(
                        future: func(email,bidData,index),
                        builder: (context, snapshot) {
                        email=snapshot.data ?? "Loading..";
                       return ListTile(
                          title: Text('$name:  $email', style: const TextStyle(color: Colors.black)),
                          subtitle: Text('\৳${bidAmount}',
                              style: const TextStyle(color: Colors.grey)),
                        );
                      },);
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

  func(email,bidData,index)async{
    try {

      email=await FirebaseFirestore.instance
          .collection("Users")
          .doc(bidData["uid"])
          .get();
    //  print('${email.data()!["name"]} $index');
      return '${email.data()!["email"]}';
    }catch(e){}
  }

  statuscheck(String id, BuildContext context) {
    _timer=Timer.periodic(Duration(seconds: 1), (timer) async {
      try {
        DateTime now = DateTime.now();
        print(now);

        DocumentSnapshot auction = await FirebaseFirestore.instance
            .collection('products')
            .doc(id)
            .get();

        DateTime endTime = DateTime.parse(auction['auctionEndTime']);

        DateTime startTime = DateTime.parse(auction['auctionStartTime']);

        //  widget.product.status=auction['status'];


        if(auction['status']=='ended' && widget.product.status=='active'){
          setState(() {
            widget.product.status='ended';
          });
          showDiag(context,widget.product.highBidderName,widget.product.currentPrice.toString());
          _timer?.cancel();
          return;
        }
       else if(startTime.isBefore(now) && widget.product.status == 'upcoming'){
          await auction.reference.update({'status': 'active'});

          setState(() {
            widget.product.status='active';
          });
        }

        else if (now.isAfter(endTime) && widget.product.status == 'active') {
          await auction.reference.update({'status': 'ended'});
          print('Auction ${auction.id} has ended.');
          print('.................................................');

          setState(() {
            widget.product.status='ended';
          });

          showDiag(context,widget.product.highBidderName,widget.product.currentPrice.toString());
          _timer?.cancel();
          return;

        }


      if(auction["status"]=='ended'){
        if(widget.product.status == 'active'){
          setState(() {
            widget.product.status='ended';
          });
          showDiag(context,widget.product.highBidderName,widget.product.currentPrice.toString());
          _timer?.cancel();
          return;
        }
        _timer?.cancel();
      }
      } catch (e) {
        print('Error in statusCheck: $e');
        _timer?.cancel();
      }
    });
  }

  showDiag(context,String name,String price){
    showDialog(context: context,
      builder: (context) =>
          AlertDialog( shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Smooth rounded corners
          ),
            backgroundColor: Colors.white,
            title: Column(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 50, // Success icon
                ),
                const SizedBox(height: 10),
                Text(
                  'Sold to $name',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            content: Text(
              'Final price: ৳$price',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );



  }

  showLogDiag(){
    showDialog(context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            backgroundColor: Colors.white,
            title: Column(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orangeAccent,
                  size: 50, // Large warning icon
                ),
                const SizedBox(height: 10),
                Text(
                  'You are not logged in',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            content: Text(
              'Please log in to access this feature.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              Wrap(
                spacing: 10,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => login()),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                ],
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
  late Timer _timer1;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.product.getRemainingTime();
    _startTimer();
  }


  void _startTimer() {
    _timer1 = Timer.periodic(Duration(seconds: 1), (timer) {

      setState(() {
        _remainingTime = widget.product.getRemainingTime();
        if (_remainingTime <= 0) {
          _timer1.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer1.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(widget.product.auctionStartTime.isBefore(DateTime.now()))
        Text('Time Remaining: ${widget.product.formatRemainingTime(
            _remainingTime)}', style: TextStyle(fontWeight: FontWeight.w700),)
        else
          Text('Auction has not Started yet', style: TextStyle(fontWeight: FontWeight.w700),)


      ],
    );
  }


}
