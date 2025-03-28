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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final boxheight=290.0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
            bottom: TabBar(
              isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.white,
                splashFactory: NoSplash.splashFactory,
                indicatorColor: Colors.white,
                labelStyle: TextStyle(color: Colors.blue,fontSize: 12,fontWeight: FontWeight.bold),

               
                tabs: [
              Tab(
                child: Text("All"),
              ),
              Tab(
                child: Text("Active"),
              ),
              Tab(
                child: Text("Ended"),
              ),
                  Tab(
                    child: Text("Upcoming"),
                  ),


            ]),


          ),
          drawer: Drawer(

            backgroundColor: Colors.white,
            width: 280,
          ),
          floatingActionButton:ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductForm(),));
          }, child: Text("Add Product")) ,

          body:TabBarView(
            children: [
              Container(
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

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //childAspectRatio: 0.75,
                        mainAxisExtent: boxheight,
                        crossAxisCount: 2,

                      ),

                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(product: product);
                      },
                    );
                  },
                ),
              ),
              Container(
                child: StreamBuilder<QuerySnapshot>(

                  stream: _firestore.collection('products').where("status",isEqualTo: "active").orderBy("auctionEndTime",descending: false).snapshots(),
                  //stream: _firestore.collection('products').orderBy("auctionEndTime",descending: false).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No products available.'));
                    }
                    final products = snapshot.data!.docs.map((doc) => Product.fromFirestore(doc)).toList();

                    monitorAuctionStatus();

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                       // childAspectRatio: 0.75,
                        mainAxisExtent: boxheight,
                        crossAxisCount: 2,

                      ),

                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(product: product);
                      },
                    );
                  },
                ),
              ),
              Container(
                child: StreamBuilder<QuerySnapshot>(

                  stream: _firestore.collection('products').where("status",isEqualTo: "ended").orderBy("auctionEndTime",descending: false).snapshots(),
                 // stream: _firestore.collection('products').orderBy("auctionEndTime",descending: false).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No products available.'));
                    }
                    final products = snapshot.data!.docs.map((doc) => Product.fromFirestore(doc)).toList();

                    monitorAuctionStatus();

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //  childAspectRatio: 0.75,
                        mainAxisExtent: boxheight,
                        crossAxisCount: 2,

                      ),

                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(product: product);
                      },
                    );
                  },
                ),
              ),
              Container(
                child: StreamBuilder<QuerySnapshot>(

                  stream: _firestore.collection('products').where("status",isEqualTo: "upcoming").orderBy("auctionEndTime",descending: false).snapshots(),
                  //stream: _firestore.collection('products').orderBy("auctionEndTime",descending: false).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No products available.'));
                    }
                    final products = snapshot.data!.docs.map((doc) => Product.fromFirestore(doc)).toList();

                    monitorAuctionStatus();

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //childAspectRatio: 0.75,
                        mainAxisExtent: boxheight,
                        crossAxisCount: 2,

                      ),

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
      ),
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
      child: Container(
      //  padding: EdgeInsets.all(8),
       // color: Colors.white70,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
         image: DecorationImage(image:  NetworkImage(widget.product.imageUrl!,),fit: BoxFit.fitHeight),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(149, 157, 165, 0.2), // RGBA color
              offset: Offset(0, 8), // X: 0px, Y: 8px
              blurRadius: 24, // Blur radius: 24px
              spreadRadius: 0, // Spread radius: 0px (default)
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Stack(
              alignment: Alignment.topLeft,
              children: [

                if (widget.product.imageUrl != null)
                  Container(
                  //  height: 160,
                    // width: 400,
                    decoration: BoxDecoration(
                    // border: Border.symmetric(horizontal: BorderSide(color: Colors.grey,width: 1,strokeAlign: 0.3)),
                      borderRadius: BorderRadius.circular(15),
                     // image: DecorationImage(image:  NetworkImage(widget.product.imageUrl!,),fit: BoxFit.fitWidth),
                    ),

                  ),

                if(widget.product.status=='upcoming')
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(17, 12, 46, 0.15), // Converted RGBA color
                          offset: Offset(0, 48), // X and Y offset
                          blurRadius: 100, // Blur radius
                          spreadRadius: 0, // Spread radius
                        ), //BoxShadow//BoxShadow
                      ],
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin:  EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
                    child:  Text('Upcoming',style: TextStyle(fontSize: 8,color: Colors.white,fontWeight: FontWeight.bold)) ,
                  )
                else if(widget.product.auctionStartTime.isBefore(DateTime.now()))
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(17, 12, 46, 0.15), // Converted RGBA color
                          offset: Offset(0, 48), // X and Y offset
                          blurRadius: 100, // Blur radius
                          spreadRadius: 0, // Spread radius
                        ), //BoxShadow//BoxShadow
                      ],
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin:  EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
                    child:widget.product.status=="active" ? Text(' ${widget.product.formatRemainingTime(_remainingTime)}',style: TextStyle(fontSize: 8,color: Colors.white,fontWeight: FontWeight.bold)): Text('Ended',style: TextStyle(fontSize: 8,color: Colors.white,fontWeight: FontWeight.bold)) ,
                  )
              ],
            ),
            //  Image.network(widget.product.imageUrl!, height: 150, width: double.infinity, fit: BoxFit.cover),

           Container(
             height: 68,
              margin: EdgeInsets.all(5),
             padding: EdgeInsets.all(5),
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(5),
               boxShadow: [
                 BoxShadow(
                   color: Color.fromRGBO(17, 12, 46, 0.15), // Converted RGBA color
                   offset: Offset(0, 48), // X and Y offset
                   blurRadius: 100, // Blur radius
                   spreadRadius: 0, // Spread radius
                 ), //BoxShadow//BoxShadow
               ],
             ),
             width: double.infinity,
            // color: Colors.grey,
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                 Container(
                   width: 110,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(widget.product.name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                       SizedBox(height: 6),
                       Text(widget.product.description,style: TextStyle(fontSize: 7,color:Colors.grey),maxLines: 3,overflow: TextOverflow.ellipsis,),
                       // SizedBox(height: 8),
                       //  Text("Owner: ${widget.product.sellerName}"),
                       //  SizedBox(height: 8),
              //         Text('Starting Price: \$${widget.product.startingPrice.toStringAsFixed(2)}',style: TextStyle(fontSize: 8,)),
                       //  SizedBox(height: 8),
              //         Text('Current Price: \$${widget.product.currentPrice.toStringAsFixed(2)}',style: TextStyle(fontSize: 8,)),
                       // SizedBox(height: 8),
                       // Text('Status: ${widget.product.status}'),
                       // SizedBox(height: 8),
                       //  Text('Time Remaining: ${widget.product.formatRemainingTime(_remainingTime)}',style: TextStyle(fontSize: 8,)),
                     ],
                   ),
                 ),

                 Container(
                  // width: 50,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Column(
                         children: [

                           Text('Starting Price',style: TextStyle(fontSize: 8,color:Colors.grey)),
                           Text('\$${widget.product.startingPrice.toStringAsFixed(2)}',style: TextStyle(fontSize: 9,fontWeight: FontWeight.bold)),

                         ],
                       ),
                       //  SizedBox(height: 8),
                       Column(
                         children: [
                           Text('Current Price',style: TextStyle(fontSize: 8,color:Colors.grey)),
                           Text('\$${widget.product.currentPrice.toStringAsFixed(2)}',style: TextStyle(fontSize: 9,fontWeight: FontWeight.bold)),

                         ],
                       ) ],
                   ),
                 ),
               ],
             )
           ),

          ],
        ),
      ),
    );
  }
}
