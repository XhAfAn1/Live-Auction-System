import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:liveauctionsystem/classes/user.dart';

import '../classes/Product.dart';
import '../firebase/Authentication.dart';
import '../firebase/firebase message api.dart';
import '../home/profile.dart';
import '../main.dart';
import 'add_product.dart';

class admin_panel extends StatefulWidget {
  const admin_panel({super.key});

  @override
  State<admin_panel> createState() => _admin_panelState();
}

class _admin_panelState extends State<admin_panel> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  int pid = 1;

  panelid(int id) {
    //homepage
    if (id == 1) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 100
                ),
                children: [
                  Container(
                    child: FutureBuilder(
                      future:
                          FirebaseFirestore.instance
                              .collection("products")
                              .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Card(
                            elevation: 0,
                            color: Colors.red[50],
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Total Products"),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "0",
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          return Card(
                            elevation: 0,
                            color: Colors.red[50],
                            child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Total Products"),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          "${snapshot.data!.docs.length}",
                                          style: TextStyle(fontSize: 30),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          );
                        }
                        return Text("Data not found");
                      },
                    ),
                  ),
                  Container(


                    child: FutureBuilder(
                      future:
                          FirebaseFirestore.instance.collection("Users").get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(width: 1.5,color: Colors.black12)),
                            elevation: 0,
                            color: Colors.white54,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [Icon(Icons.person,color: Colors.black87,size: 20,),
                                      SizedBox(width: 5,),
                                      Text("Total Users"),],
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "0",
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          // return Center(child: Text("Total Products: ${snapshot.data!.docs.length}"));
                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(width: 1.5,color: Colors.black12)),
                            elevation: 0,
                            color: Colors.white54,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [Icon(Icons.person,color: Colors.black87,size: 20,),
                                      SizedBox(width: 5,),
                                      Text("Total Users"),],
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "${snapshot.data!.docs.length}",
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Text("Data not found");
                      },
                    ),
                  ),
                  Container(
                    child: FutureBuilder(
                      future:
                          FirebaseFirestore.instance
                              .collection("products")
                              .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Card(
                            elevation: 0,
                            color: Colors.blue[50],
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Total Sell"),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "0 ৳",
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          // return Center(child: Text("Total Products: ${snapshot.data!.docs.length}"));
                          final docs = snapshot.data!.docs;
                          int totalSum = docs.fold<int>(0, (prev, doc) {
                            if (doc['status'] == 'ended') {
                              final price = doc['currentPrice'];
                              return prev + (price is int ? price : 0);
                            } else {
                              return prev;
                            }
                          });
                          return Card(
                            elevation: 0,
                            color: Colors.blue[50],
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Total Sell"),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "$totalSum ৳",
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                        }
                        return Text("Data not found");
                      },
                    ),
                  ),
                  Container(
                    child: FutureBuilder(
                      future:
                      FirebaseFirestore.instance
                          .collection("request")
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Card(
                            elevation: 0,
                            color: Colors.yellow[50],
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Total request"),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "0",
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          // return Center(child: Text("Total Products: ${snapshot.data!.docs.length}"));
                          final totalSum = snapshot.data!.docs.length;
                          return Card(
                            elevation: 0,
                            color: Colors.yellow[50],
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Total Request"),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "$totalSum",
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                        }
                        return Text("Data not found");
                      },
                    ),
                  ),
                  Container(
                    child: FutureBuilder(
                      future:
                      FirebaseFirestore.instance
                          .collection("products").where('paid',isEqualTo: true)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Card(
                            elevation: 0,
                            color: Colors.green[50],
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ready for delivery"),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "0",
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          // return Center(child: Text("Total Products: ${snapshot.data!.docs.length}"));
                          final totalSum = snapshot.data!.docs.length;
                          return Card(
                            elevation: 0,
                            color: Colors.green[50],
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ready for delivery"),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "$totalSum",
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                        }
                        return Text("Data not found");
                      },
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(height: 10),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection("products").where("status",isNotEqualTo: "upcoming").get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No data available"));
                }

                final docs = snapshot.data!.docs;
                final products = docs.map((doc) => Product.fromFirestore(doc)).toList();


                final List<FlSpot> lineData = [];
                for (int i = 0; i < products.length; i++) {
                  lineData.add(FlSpot(i.toDouble(), products[i].currentPrice.toDouble()));
                }

                double maxY = 0;
                if (lineData.isNotEmpty) {
                  maxY = lineData.reduce((a, b) => a.y > b.y ? a : b).y;
                  maxY = maxY+100;
                }

                final yLabels = [
                  maxY,
                  maxY - 500,
                  maxY - 800,
                  maxY - 900,
                  maxY - 950,
                  maxY - 990,
                ];

                return Container(
                  margin: const EdgeInsets.all(10.0),
                  width: double.infinity, // Make it responsive
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          'Price chart',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Combined chart
                        Expanded(
                          child: Row(
                            children: [

                              SizedBox(
                                width: 40,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: yLabels.map((value) => Text(
                                    '${value.toInt()}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 10,
                                    ),
                                  )).toList(),
                                ),
                              ),
                              const SizedBox(width: 5),
                              // Chart area
                              Expanded(
                                child: Stack(
                                  children: [
                                    // Grid lines
                                    CustomPaint(
                                      size: Size.infinite,
                                      painter: GridPainter(),
                                    ),

                                    // Line Chart
                                    LineChart(
                                      LineChartData(
                                        gridData: FlGridData(show: false),
                                        titlesData: FlTitlesData(
                                          show: false,

                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(showTitles: false),
                                          ),
                                          topTitles: AxisTitles(
                                            sideTitles: SideTitles(showTitles: false),
                                          ),
                                          rightTitles: AxisTitles(
                                            sideTitles: SideTitles(showTitles: false),
                                          ),
                                        ),
                                        borderData: FlBorderData(show: false),
                                        minX: 0,
                                        maxX: lineData.length - 1.0,
                                        minY: 0,
                                        maxY: maxY,
                                        lineTouchData: LineTouchData(
                                          enabled: true,
                                          touchTooltipData: LineTouchTooltipData(
                                            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                              return touchedBarSpots.map((barSpot) {
                                                final index = barSpot.x.toInt();
                                                final value = barSpot.y;

                                                return LineTooltipItem(
                                                  '${docs[index]['name']}\n',
                                                  const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: '${value.toInt()} ৳',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.normal,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }).toList();
                                            },
                                          ),
                                        ),
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: lineData,
                                            isCurved: true,
                                            color:  Colors.green, // Orange/red color
                                            barWidth: 3,
                                            isStrokeCapRound: true,
                                            dotData: FlDotData(
                                              show: true,
                                              getDotPainter: (spot, percent, barData, index) {
                                                return FlDotCirclePainter(
                                                  radius: 3,
                                                  color: docs[index]['status'] == 'ended' ? Colors.white : Colors.white,
                                                  strokeWidth: 2,
                                                  strokeColor:docs[index]['status'] == 'ended' ? Colors.black : Colors.green,
                                                );
                                              },
                                            ),
                                            belowBarData: BarAreaData(
                                              show: true,
                                              color: Colors.green.withOpacity(0.1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          ]
      ));
    }

    //show All users
    if (id == 2) {
      return FutureBuilder(
        future: FirebaseFirestore.instance.collection("Users").get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            final users =
                docs.map((doc) => UserModel.fromJson(doc.data())).toList();
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  elevation: 0.5,
                  color: Colors.grey.shade50,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey[300],
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image:
                                    user.profileImageUrl.isNotEmpty
                                        ? NetworkImage(user.profileImageUrl)
                                        : NetworkImage(
                                          "https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/HD_transparent_picture.png/1200px-HD_transparent_picture.png",
                                        ),
                              ),
                            ),

                            child:
                                user.profileImageUrl.isEmpty
                                    ? Icon(Icons.person, color: Colors.white)
                                    : null,
                          ),
                          SizedBox(width: 20),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Text(
                                  user.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("Email: ${user.email}"),
                                Text("Phone: ${user.phoneNumber}"),
                                Text("Address: ${user.address}"),
                                Text("Admin: ${user.admin ? "Yes" : "No"}"),
                                Text(
                                  "Joined: ${user.createdAt.toLocal().toString().split(' ')[0]}",
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No users found."));
          }
        },
      );
    }

    //show all products
    if (id == 3) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("products").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            final products =
            docs.map((doc) => Product.fromFirestore(doc)).toList();
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final docId = docs[index].id;

                return Card(
                  elevation: 0.5,
                  color: Colors.grey.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl ?? '',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                product.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Divider(),
                              Text("Seller: ${product.sellerName}"),
                              Text("Top-Bidder: ${product.highBidderName}"),
                              Text("Price: ${product.currentPrice}"),
                              Text(
                                "Ends: ${product.auctionEndTime.toLocal().toString().split(' ')[0]}",
                              ),
                              Text("Status: ${product.status}"),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Delete Product"),
                                        content: Text("Are you sure you want to delete this product ?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: Text("Delete", style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      try {
                                        // Delete Firestore doc
                                        await FirebaseFirestore.instance
                                            .collection("products")
                                            .doc(docId)
                                            .delete();

                                        // Delete image from Firebase Storage
                                        final imageRef = FirebaseStorage.instance.refFromURL(product.imageUrl);
                                        await imageRef.delete();

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Product deleted')),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Failed to delete product')),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: Icon(Icons.send, color: Colors.blue),
                                  onPressed: () async{
                                    final winner =await FirebaseFirestore.instance.collection("Users").doc(product.highBidderId).get();
                                    final fcm = winner.get("fcmToken");
                                    print(fcm);
                                    FirebaseApi().sendNotification(fcm,"Congratulations","You have won the auction for ${product.name}");
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No products found."));
          }
        },
      );
    }


    //show all reuqest
    if (id == 4) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("request").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No request found."));
          }
          else if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            final products =
            docs.map((doc) => Product.fromFirestore(doc)).toList();
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 0.5,
                  color: Colors.grey.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl ?? '',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                      //  product.description,
                                        "Description",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      ElevatedButton(onPressed: () async{
                                       await FirebaseFirestore.instance.collection("products").doc(product.productId).set(product.toMap());
                                       await FirebaseFirestore.instance.collection("request").doc(product.productId).delete();

                                      }, child: Text("Accept"))
                                    ],
                                  )
                                ],
                              ),
                              Divider(),
                              Text("Seller: ${product.sellerName}"),
                             // Text("Top-Bidder: ${product.highBidderName}"),
                              Text("Price: ${product.currentPrice}"),
                              Text(
                                "Ends: ${product.auctionEndTime.toLocal().toString().split(' ')[0]}",
                              ),
                              Text("Status: ${product.status}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No products found."));
          }
        },
      );
    }

    if (id == 5) {

    }
    // show all item storage
    if (id == 6) {
      return FutureBuilder(
        future: FirebaseStorage.instance.ref('itemPhoto/').listAll(),
        builder: (context, AsyncSnapshot<ListResult> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!.items.isNotEmpty) {
            final items = snapshot.data!.items;

            return FutureBuilder(
              future: Future.wait(items.map((ref) async {
                final url = await ref.getDownloadURL();
                return {'ref': ref, 'url': url};
              })),
              builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> urlSnapshot) {
                if (urlSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (urlSnapshot.hasData) {
                  final imageEntries = urlSnapshot.data!;

                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: imageEntries.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final imageEntry = imageEntries[index];
                      final imageUrl = imageEntry['url'];
                      final imageRef = imageEntry['ref'] as Reference;

                      return Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(imageUrl, fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                icon: Icon(Icons.delete, color: Colors.white, size: 18),
                                onPressed: () async {
                                  await imageRef.delete();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image deleted')));
                                  // Refresh UI after deletion
                                  (context as Element).markNeedsBuild();
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return Text("Failed to load image URLs.");
                }
              },
            );
          } else {
            return Text("No photos found.");
          }
        },
      );
    }

    //private
    if (id == 7) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("private rooms").snapshots(),
        builder: (context, roomSnapshot) {
          if (roomSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!roomSnapshot.hasData || roomSnapshot.data!.docs.isEmpty) {
            return Center(child: Text("No private rooms found."));
          }

          final rooms = roomSnapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: rooms.length,
            itemBuilder: (context, roomIndex) {
              final room = rooms[roomIndex];
              final roomId = room.id;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Room ID: $roomId",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("private rooms")
                        .doc(roomId)
                        .collection("products")
                        .get(),
                    builder: (context, productSnapshot) {
                      if (productSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!productSnapshot.hasData || productSnapshot.data!.docs.isEmpty) {
                        return Text("No products in this room.");
                      }

                      final productDocs = productSnapshot.data!.docs;
                      final products = productDocs
                          .map((doc) => Product.fromFirestore(doc))
                          .toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final docId = productDocs[index].id;

                          return Card(
                            elevation: 0.5,
                            color: Colors.grey.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      product.imageUrl ?? '',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[300],
                                        child: Icon(Icons.image_not_supported),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          product.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Divider(),
                                        Text("Seller: ${product.sellerName}"),
                                        Text("Top-Bidder: ${product.highBidderName}"),
                                        Text("Price: ${product.currentPrice}"),
                                        Text(
                                          "Ends: ${product.auctionEndTime.toLocal().toString().split(' ')[0]}",
                                        ),
                                        Text("Status: ${product.status}"),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 32),
                ],
              );
            },
          );
        },
      );

    }

    // delivary request
    if (id == 8) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("paid", isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            final products = docs.map((doc) => Product.fromFirestore(doc)).toList();

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final buyerId = product.highBidderId;

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection("Users").doc(buyerId).get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final data = userSnapshot.data?.data() as Map<String, dynamic>? ?? {};
                    final address = data['address'] ?? 'Address not available';

                    return Card(
                      elevation: 0.5,
                      color: Colors.grey.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.imageUrl ?? '',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    product.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Divider(),
                                  Text("Seller: ${product.sellerName}"),
                                  Text("Buyer: ${product.highBidderName}"),
                                  Text("Price: ${product.currentPrice}"),
                                  Text("Address: $address"),
                                  Text("Payment Status: Paid"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text("No products found."));
          }
        },
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Admin Panel"),
        actions: [
          //if(FirebaseAuth.instance.currentUser != null)
          Container(
            child: FutureBuilder<DocumentSnapshot>(
              future:
                  FirebaseFirestore.instance
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
                    onTap: () {
                      if (FirebaseAuth.instance.currentUser == null)
                        showLogDiag(context);
                      else
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => profile(
                                  uid: FirebaseAuth.instance.currentUser!.uid,
                                ),
                          ),
                        );
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

                  onTap: () {
                    if (FirebaseAuth.instance.currentUser == null)
                      showLogDiag(context);
                    else
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => profile(
                                uid: FirebaseAuth.instance.currentUser!.uid,
                              ),
                        ),
                      );
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        (imageUrl != null && imageUrl.isNotEmpty)
                            ? NetworkImage(imageUrl)
                            : null,
                    backgroundColor: Colors.grey[300],
                    child:
                        (imageUrl == null || imageUrl.isEmpty)
                            ? Icon(Icons.person, size: 20, color: Colors.white)
                            : null,
                  ),
                );
              },
            ),
          ),

          Container(width: 20),
        ],
      ),
      drawer: Drawer(
        shape: LinearBorder(),
        backgroundColor: Colors.white,
        width: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DrawerHeader(
            // //   margin: EdgeInsets.zero,
            // //   decoration: const BoxDecoration(
            // //     // border: Border(
            // //     //   bottom: BorderSide(color: Colors.grey, width: 0.2),
            // //     // ),
            // //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: const [
            //       // CircleAvatar(
            //       //   radius: 28,
            //       //   backgroundImage: AssetImage('assets/avatar.png'), // Replace with your asset
            //       // // ),
            //       // SizedBox(height: 12),
            //       // Text(
            //       //   "Admin Panel",
            //       //   style: TextStyle(
            //       //     fontSize: 18,
            //       //     fontWeight: FontWeight.w600,
            //       //   ),
            //       // ),
            //
            //     ],
            //   ),
            //  ),
            SizedBox(
              height: 50,
            ),
            Expanded(
              child: ListView(
                children: [
                  const Divider(height: 32, thickness: 0.5),
                  ListTile(
                    leading: Icon(Icons.dashboard_outlined, size: 22),
                    title: Text("Dashboard", style: TextStyle(fontSize: 16)),
                    onTap: () {
                      setState(() {
                        pid = 1;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person_outline, size: 22),
                    title: Text("Users", style: TextStyle(fontSize: 16)),
                    onTap: () {
                      setState(() {
                        pid = 2;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.shopping_bag_outlined, size: 22),
                    title: Text("Products", style: TextStyle(fontSize: 16)),
                    onTap: () {
                      setState(() {
                        pid = 3;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.lock_outline, size: 22),
                    title: Text("Private auctions", style: TextStyle(fontSize: 16)),
                    onTap: () {
                      setState(() {
                        pid = 7;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.request_page_outlined, size: 22),
                    title: Text("Requests", style: TextStyle(fontSize: 16)),
                    onTap: () {
                      setState(() {
                        pid = 4;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library_outlined, size: 22),
                    title: Text("Delivary Request", style: TextStyle(fontSize: 16)),
                    onTap: () {
                      setState(() {
                        pid = 8;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.add_box_outlined, size: 22),
                    title: Text("Add Product", style: TextStyle(fontSize: 16)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddProductForm(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library_outlined, size: 22),
                    title: Text("Item Photos", style: TextStyle(fontSize: 16)),
                    onTap: () {
                      setState(() {
                        pid = 6;
                      });
                      Navigator.pop(context);
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

      body: panelid(pid),
    );
  }
}
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    final height = size.height;
    final width = size.width;

    // Draw horizontal grid lines
    final lineCount = 5;
    final lineSpacing = height / lineCount;

    for (int i = 0; i <= lineCount; i++) {
      final y = i * lineSpacing;
      canvas.drawLine(Offset(0, y), Offset(width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}