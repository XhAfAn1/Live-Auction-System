import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liveauctionsystem/adminPanel/add_product.dart';
import 'package:liveauctionsystem/home/private%20bidding/private%20room.dart';
import 'package:liveauctionsystem/home/profile.dart';
import 'package:liveauctionsystem/login%20signup/login.dart';
import '../classes/Product.dart';
import '../firebase/Authentication.dart';
import '../firebase/ai_chatbot.dart';
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
    monitorAuctionStatus();
  }
  @override
  void dispose() {
    // TODO: implement dispose

    stopMonitoring();
    super.dispose();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String searchName = "";
  final boxheight=290.0;

  int boxcount() {
    if (MediaQuery
        .sizeOf(context)
        .width > 1500.0) {
      return 6;
    }
    else if (MediaQuery
        .sizeOf(context)
        .width > 1300.0) {
      return 5;
    }
    else if (MediaQuery
        .sizeOf(context)
        .width > 1000.0) {
      return 4;
    }

    else if (MediaQuery
        .sizeOf(context)
        .width > 650.0) {
      return 3;
    }
    else if (MediaQuery
        .sizeOf(context)
        .width > 300.0) {
      return 2;
    }

    else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 4,
      child: RefreshIndicator(
        onRefresh: ()async{
          await Future.delayed(Duration(seconds: 1));
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Builder(
          builder: (context) => GestureDetector(
            onHorizontalDragUpdate: (e){
              if(e.delta.dx>0){
                Scaffold.of(context).openDrawer();
              }
            },
          onTap: () {
          Scaffold.of(context).openDrawer(); // Open drawer when tapped
          },
          child: Container(

               // width: 70,
               // height: 30,
                padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                decoration: BoxDecoration(
                 // color: Color(0xffa8ed4f),
                  borderRadius: BorderRadius.circular(40)
                ),
                child: //Text("AucSy",textAlign: TextAlign.center,style: TextStyle(color:Color(0xff093125),fontWeight: FontWeight.w700,fontSize: 25,fontFamily: ''),),
                  Image.asset('assets/image.png', width: 120, // Set explicit width
                    height: 200,),

              ),)),
              titleSpacing: 10,
              actions: [
                //if(FirebaseAuth.instance.currentUser != null)
                Container(
                  child: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .get(),

                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[300],
                          child: CircularProgressIndicator(
                            padding: EdgeInsets.all(13),
                            strokeWidth: 0.7,
                          ),
                        );
                      }

                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return InkWell(
                          splashFactory: NoSplash.splashFactory,
                          radius: 50,
                          onTap: (){
                            if(FirebaseAuth.instance.currentUser == null)
                              showLogDiag(context);
                            else
                            Navigator.push(context, MaterialPageRoute(builder: (context) => profile(uid: FirebaseAuth.instance.currentUser!.uid,),));
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey[300],
                            child: Icon(Icons.person, size: 20, color: Colors.white),
                          ),
                        );
                      }

                      String? imageUrl = snapshot.data!.get("profileImageUrl");

                      return InkWell(
                        splashFactory: NoSplash.splashFactory,
                        radius: 50,

                        onTap: (){
                          if(FirebaseAuth.instance.currentUser == null)
                            showLogDiag(context);
                          else
                          Navigator.push(context, MaterialPageRoute(builder: (context) => profile(uid: FirebaseAuth.instance.currentUser!.uid,),));
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                              ? NetworkImage(imageUrl)
                              : null,
                          backgroundColor: Colors.grey[300],
                          child: (imageUrl == null || imageUrl.isEmpty)
                              ? Icon(Icons.person, size: 20, color: Colors.white)
                              : null,
                        ),
                      );
                    },
                  ),
                ),




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
                  labelStyle: TextStyle(color: Color(0xB2ABD14C),fontSize: 13,fontWeight: FontWeight.bold),


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
              shape: LinearBorder(),
              backgroundColor: Colors.white,
              width: 280,
              child: Column(
               // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DrawerHeader(
                    margin: EdgeInsets.zero,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white, width: 0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage('assets/icon.jpg'),fit: BoxFit.fill),
                          ),
                        ),
                        // CircleAvatar(
                        //   radius: 28,
                        //   backgroundImage: AssetImage('assets/avatar.png'), // Replace with your asset
                        // // ),
                        // SizedBox(height: 12),
                        // Text(
                        //   "Admin Panel",
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),

                      ],
                    ),
                   ),
                  // SizedBox(
                  //   height: 50,
                  // ),
                  Expanded(
                    child: ListView(
                      children: [
                        const Divider(height: 32, thickness: 0.5),
                        ListTile(
                          leading: Icon(Icons.home, size: 22),
                          title: Text("Home", style: TextStyle(fontSize: 16)),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(Icons.shopping_bag_outlined, size: 22),
                          title: Text("View My Items", style: TextStyle(fontSize: 16)),
                          onTap: () {
                            if(FirebaseAuth.instance.currentUser == null)
                              showLogDiag(context);
                            else
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ShowMyItems(),));

                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.privacy_tip_outlined, size: 22),
                          title: Text("Private room", style: TextStyle(fontSize: 16)),
                          onTap: () {
                            if(FirebaseAuth.instance.currentUser == null)
                              showLogDiag(context);
                            else
                              Navigator.push(context, MaterialPageRoute(builder: (context) => private_room(),));

                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.help_outline, size: 22),
                          title: Text("Support", style: TextStyle(fontSize: 16)),
                          onTap: () {
                            if(FirebaseAuth.instance.currentUser == null)
                              showLogDiag(context);
                            else
                              Navigator.push(context, MaterialPageRoute(builder: (context) => GeminiChatPage(init_text: "This is a support chat for my auction app.",isSupport: true,),));


                          },
                        ),

                        const Divider(height: 32, thickness: 0.5),
                        if (FirebaseAuth.instance.currentUser != null)
                          ListTile(
                            leading: Icon(Icons.logout, size: 22),
                            title: Text("Logout", style: TextStyle(fontSize: 16)),
                            onTap: () {
                              Authentication().signout(context);
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
           floatingActionButton:(!kIsWeb)?ElevatedButton(style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff093125),
              foregroundColor: Colors.white,
              elevation: 1,
             // padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),onPressed: () {
              if(FirebaseAuth.instance.currentUser == null)
                showLogDiag(context);
              else
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductForm(),));
            }, child: Text("Add Product")):null ,

            body:TabBarView(
              children: [
                Container(
                  child: Column(
                  //  mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
                              prefixIcon: Icon(Icons.search),


                            ),
                          //  controller: search,
                            onChanged: searched


                          ),
                        // color: Colors.red,
                          width: double.infinity,
                         // width: 400,
                          height: 40,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          //stream: _firestore.collection('products').where("status",isEqualTo: "active").orderBy("auctionEndTime",descending: false).snapshots(),
                          stream: searchName!="" ? _firestore.collection('products').where("name", isEqualTo: searchName).snapshots() : _firestore.collection('products').orderBy("auctionEndTime",descending: false).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return Center(child: Text('No products available.'));
                            }
                            final products = snapshot.data!.docs.map((doc) => Product.fromFirestore(doc)).toList();

                            // monitorAuctionStatus();

                            return GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                //childAspectRatio: 0.75,
                                mainAxisExtent: boxheight,
                                crossAxisCount: boxcount(),

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

                   //   monitorAuctionStatus();

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                         // childAspectRatio: 0.75,
                          mainAxisExtent: boxheight,
                          crossAxisCount: boxcount(),

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

                    //  monitorAuctionStatus();

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //  childAspectRatio: 0.75,
                          mainAxisExtent: boxheight,
                          crossAxisCount: boxcount(),

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

                    //  monitorAuctionStatus();

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //childAspectRatio: 0.75,
                          mainAxisExtent: boxheight,
                          crossAxisCount: boxcount(),

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
      ),
    );
  }

  void searched(String value) {
    setState(() {
      searchName=value;
    });

    print(value);
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

      splashFactory: NoSplash.splashFactory,
      borderRadius:BorderRadius.circular(5) ,
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Singleproductview(product: widget.product),));
      },
      child: Container(
      //  padding: EdgeInsets.all(8),
       // color: Colors.white70,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
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
             height: 60,
              margin: EdgeInsets.only(left: 5,right: 5,bottom: 12),
             padding: EdgeInsets.only(left: 8,right: 8),
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
                  // width: 120,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.end,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(widget.product.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
                       SizedBox(height: 8),
                       Container(
                           decoration: BoxDecoration(
                             color: Color(0xffa8ed4f),
                             borderRadius: BorderRadius.circular(2.5),
                           ),
                           padding: EdgeInsets.symmetric(horizontal: 6,vertical: 1),
                           child: Text('Price: \৳${widget.product.startingPrice}',style: TextStyle(fontSize: 8,color:Color(0xff093125),fontWeight: FontWeight.bold),)),
                       SizedBox(height: 8),
                      // Text(widget.product.description,style: TextStyle(fontSize: 7,color:Colors.grey),maxLines: 3,overflow: TextOverflow.ellipsis,),
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
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [

                       //  SizedBox(height: 8),
                       Column(
                         mainAxisAlignment: MainAxisAlignment.end,
                         crossAxisAlignment: CrossAxisAlignment.end,
                         children: [
                           Text('BID',style: TextStyle(fontSize: 10,color:Colors.grey)),
                           Text('\৳${widget.product.currentPrice}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Color(0xff093125))),

                         ],
                       ),
                       SizedBox(height: 6),

                     ],
                   ),
                 ),
               ],
             )
           ),
           // SizedBox(height: 5,)
          ],
        ),
      ),
    );
  }
}
