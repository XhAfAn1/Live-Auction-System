import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../classes/Product.dart';
import '../firebase/ai_chatbot.dart';
import '../login signup/login.dart';
import '../main.dart';

class Singleproductview extends StatefulWidget {
  final Product product;
  Singleproductview({required this.product, super.key});

  @override
  State<Singleproductview> createState() => _SingleproductviewState();
}

class _SingleproductviewState extends State<Singleproductview> {
  TextEditingController bidController = TextEditingController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    bidController = TextEditingController(text: (widget.product.currentPrice + 1).toString());
    // Start checking status immediately
    statuscheck(widget.product.productId, context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    bidController.dispose();
    super.dispose();
  }

  statuscheck(String id, BuildContext context) {
    _timer=Timer.periodic(Duration(seconds: 1), (timer) async {
      try {
        DateTime now = DateTime.now();
        // print(now);

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
          // print('Auction ${auction.id} has ended.');
          //  print('.................................................');

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

  showLogDiag(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 60,
            ),
            SizedBox(height: 16),
            Text(
              'Please Login',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        content: Text(
          'You need to login to place a bid',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE78F02),
              minimumSize: Size(120, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  showDiag(context, String name, String price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Icon(
              Icons.check_circle,
              color: Color(0xFFE78F02),
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Sold to $name',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        content: Text(
          'Final price: ৳$price',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE78F02),
              minimumSize: Size(120, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffbfbfb),
      appBar: AppBar(
        backgroundColor: Color(0xfffbfbfb),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.product.name,
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              if (FirebaseAuth.instance.currentUser == null)
                showLogDiag(context);
              else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GeminiChatPage(
                      init_text: widget.product.toMap(),
                      isSupport: false,
                    ),
                  ),
                );
              }
            },
            icon: Icon(Icons.live_help_outlined, color: Colors.black54),
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.product.imageUrl != null)
                Container(
                  height: 240,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.product.imageUrl!,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(maxLines: 3,
                          widget.product.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black87.withOpacity(0.5),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Starting Price', style: TextStyle(fontSize: 14, color: Colors.grey)),
                        SizedBox(height: 5),
                        Text(
                          '৳${widget.product.startingPrice}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Current bid', style: TextStyle(fontSize: 14, color: Colors.grey)),
                        SizedBox(height: 5),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("products")
                              .doc(widget.product.productId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text(
                                '৳${widget.product.currentPrice.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              );
                            }

                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return Text(
                                '৳${widget.product.currentPrice.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              );
                            }

                            var productData = snapshot.data!.data() as Map<String, dynamic>;
                            widget.product.highBidderName = productData["highBidderName"];
                            int newPrice = (productData["currentPrice"] as num).toInt();

                            if (widget.product.currentPrice < newPrice) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {

                                  widget.product.currentPrice = newPrice;
                                  bidController.text = (newPrice + 1).toString();

                              });
                            }

                            DateTime endTime = DateTime.parse(productData['auctionEndTime']);
                            if (widget.product.auctionEndTime != endTime) {
                              widget.product.auctionEndTime = endTime;
                            }

                            return Text(
                              '৳${newPrice.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300, width: 1),
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer, size: 25, color: Colors.grey),
                    SizedBox(width: 10,),
                    timer(product: widget.product),
                  ],
                ),
              ),
            //  SizedBox(height: 20),
             // if (widget.product.status == 'active')
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: TextField(
                                controller: bidController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Enter bid amount",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          int? bidAmount = int.tryParse(bidController.text);
                          if (bidAmount == null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text("Invalid bid amount")));
                            return;
                          }
                          if (FirebaseAuth.instance.currentUser == null) {
                            showLogDiag(context);
                            return;
                          }
                          widget.product.placeBid(context, bidAmount, widget.product.status);

                          final remainingTime = widget.product.auctionEndTime.difference(DateTime.now());
                          if (remainingTime.inMinutes < 1) {
                            widget.product.auctionEndTime =
                                widget.product.auctionEndTime.add(Duration(seconds: 10));

                            await FirebaseFirestore.instance
                                .collection("products")
                                .doc(widget.product.productId)
                                .update({
                              "auctionEndTime": widget.product.auctionEndTime.toIso8601String(),
                            });
                          }

                          _timer?.cancel();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF093125),
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Place your bid",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 5),
              Text(
                'Bidding History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 10),

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
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text(
                          'No bidders available.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.active) {
                    var bidDocs = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: bidDocs.length,
                      itemBuilder: (context, index) {
                        var bidData = bidDocs[index].data() as Map<String, dynamic>;
                        final name = bidData["name"] ?? "No name found";
                        final bidAmount = bidData["bid"] ?? 0;
                        Timestamp? timestamp = bidData["timestamp"];
                        DateTime bidTime = timestamp?.toDate() ?? DateTime.now();
                        Duration difference = DateTime.now().difference(bidTime);

                        String timeAgo;
                        if (difference.inSeconds < 60) {
                          timeAgo = 'less than 1m ago';
                        } else if (difference.inMinutes < 60) {
                          timeAgo = '${difference.inMinutes}m ago';
                        } else if (difference.inHours < 24) {
                          timeAgo = '${difference.inHours}h ${difference.inMinutes % 60}m ago';
                        } else {
                          timeAgo = '${difference.inDays}d ago';
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.grey.shade200,
                                  child: Text(
                                    name.isNotEmpty ? name.substring(0, 1).toUpperCase() : "?",
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        timeAgo,
                                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '৳$bidAmount',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else
                    return const Center(child: Text('No bidders available.'));
                },
              ),
              SizedBox(height: 20),
              // Simplified condition for showing bid button

             // SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class timer extends StatefulWidget {
  final Product product;
  const timer({Key? key, required this.product}) : super(key: key);

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
    return Row(
      children: [
        if (widget.product.auctionStartTime.isBefore(DateTime.now()))
          Text(
            widget.product.formatRemainingTime(_remainingTime),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _remainingTime < 60 ? Colors.red.withOpacity(0.5) : Colors.black87,
            ),
          )
        else
          Text(
            'Auction has not Started yet',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          )
      ],
    );
  }
}