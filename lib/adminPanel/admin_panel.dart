import 'dart:async';

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
Timer? _timerNoti;
class _admin_panelState extends State<admin_panel> {
  @override
  void initState() {
    // TODO: implement initState
    monitorEndNotification();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timerNoti?.cancel();
  }
  int pid = 1;
// Helper functions
  Widget _buildUserInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Color(0xFF093125).withOpacity(0.6),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF093125).withOpacity(0.8),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Color(0xFF093125).withOpacity(0.6),
        ),
        SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF093125).withOpacity(0.7),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF093125),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            icon,
            size: 16,
            color: Color(0xFF093125).withOpacity(0.6),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF093125).withOpacity(0.6),
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF093125),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Color(0xFFEAF9D9);
      case 'ended':
        return Color(0xFFFFE0E0);
      case 'pending':
        return Color(0xFFFFF4D9);
      default:
        return Color(0xFFE0E0E0);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Color(0xFF093125);
      case 'ended':
        return Colors.red[700]!;
      case 'pending':
        return Colors.orange[800]!;
      default:
        return Colors.grey[700]!;
    }
  }

  // Helper method to build chart legend items
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
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
                    child: StreamBuilder(
                      stream:
                          FirebaseFirestore.instance
                              .collection("products")
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Card(
                           // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(width: 1.5,color: Colors.grey)),
                            elevation: 0.4,
                           // color: Colors.red[50],
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Total Products",style: TextStyle(color: Color(0xff093125)),),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "0",
                                        style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Color(0xff093125)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          return Card(
                          //  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(width: 1.5,color: Colors.grey)),
                            elevation: 0.4,
                           // color: Colors.red[50],
                            child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Total Products",style: TextStyle(color: Color(0xff093125)),),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          "${snapshot.data!.docs.length}",
                                          style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Color(0xff093125)),
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


                    child: StreamBuilder(
                      stream:
                          FirebaseFirestore.instance.collection("Users").snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Card(
                          //  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(width: 1.5,color: Colors.grey)),
                            elevation: 0.4,
                           // color: Colors.white54,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [//Icon(Icons.person,color: Colors.black87,size: 20,),
                                      SizedBox(width: 5,),
                                      Text("Total Users",style: TextStyle(color: Color(0xff093125)),),],
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "0",
                                        style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Color(0xff093125)),
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
                            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(width: 1.5,color: Colors.grey)),
                            elevation: 0.4,
                            //color: Colors.white54,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [//Icon(Icons.person,color: Color(0xff093125),size: 20,),
                                      SizedBox(width: 5,),
                                      Text("Total Users",style: TextStyle(color: Color(0xff093125)),),],
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "${snapshot.data!.docs.length}",
                                        style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Color(0xff093125)),
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
                    child: StreamBuilder(
                      stream:
                          FirebaseFirestore.instance
                              .collection("products")
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Card(
                            elevation: 0.4,
                            //color: Colors.blue[50],
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Total Sell",style: TextStyle(color: Color(0xff093125)),),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "0 ৳",
                                        style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Color(0xff093125)),
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
                            elevation: 0.4,
                          //  color: Colors.blue[50],
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Total Sell",style: TextStyle(color: Color(0xff093125)),),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "$totalSum ৳",
                                        style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Color(0xff093125)),
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
                    child: StreamBuilder(
                      stream:
                      FirebaseFirestore.instance
                          .collection("request")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Card(
                            elevation: 0.4,
                          //  color: Colors.yellow[50],
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Total request",style: TextStyle(color: Color(0xff093125)),),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "0",
                                        style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Color(0xff093125)),
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
                            elevation: 0.4,
                           // color: Colors.yellow[50],
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Total Request",style: TextStyle(color: Color(0xff093125)),),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "$totalSum",
                                        style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Color(0xff093125)),
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
                    child: StreamBuilder(
                      stream:
                      FirebaseFirestore.instance
                          .collection("products").where('paid',isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Card(
                            elevation: 0.4,
                           // color: Colors.green[50],
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ready for delivery",style: TextStyle(color: Color(0xff093125)),),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "0",
                                        style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Color(0xff093125)),                                      ),
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
                            elevation: 0.4,
                           // color: Colors.green[50],
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ready for delivery",style: TextStyle(color: Color(0xff093125)),),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "$totalSum",
                                        style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Color(0xff093125)),
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
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("products").where("status",isNotEqualTo: "upcoming").snapshots(),
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
                  maxY = maxY;
                }

                final yLabels = [
                  maxY,
                  maxY - ((maxY/5)*1),
                  maxY - ((maxY/5)*2),
                  maxY - ((maxY/5)*3),
                  maxY - ((maxY/5)*4),
                  maxY - maxY,
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bidding Activity',
                                  style: TextStyle(
                                    color: const Color(0xFF093125),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Product price trends',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                _buildLegendItem('Active', Colors.green),
                                const SizedBox(width: 16),
                                _buildLegendItem('Ended', Colors.black),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
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
                                            color:  Color(0xffa8ed4f), // Orange/red color
                                            barWidth: 3,
                                            isStrokeCapRound: true,
                                            dotData: FlDotData(
                                              show: true,
                                              getDotPainter: (spot, percent, barData, index) {
                                                return FlDotCirclePainter(
                                                  radius: 3,
                                                  color: docs[index]['status'] == 'ended' ? Colors.black.withOpacity(0.5) : Colors.green.withOpacity(0.5),
                                                  strokeWidth: 2,
                                                  strokeColor:docs[index]['status'] == 'ended' ? Colors.black : Colors.green,
                                                );
                                              },
                                            ),
                                            belowBarData: BarAreaData(
                                              show: true,
                                              color: Color(0xffa8ed4f).withOpacity(0.1),
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
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF093125).withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Activity',
                          style: TextStyle(
                            color: const Color(0xFF093125),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                           setState(() {
                             pid=3;
                           });
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color: const Color(0xFF093125),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("products")
                        .orderBy('auctionEndTime', descending: true)
                        .limit(5)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(
                              color: Color(0xFF093125),
                            ),
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text("No recent activity"),
                          ),
                        );
                      }

                      final products = snapshot.data!.docs
                          .map((doc) => Product.fromFirestore(doc))
                          .toList();

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        separatorBuilder: (context, index) => const Divider(height: 1,thickness: 0.5,),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.imageUrl ?? '',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              'Bid: ${product.currentPrice} ৳',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                              //  color: _getStatusColor(product.status),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                product.status.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                 // color: _getStatusTextColor(product.status),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ]
      ));
    }

    //show All users
    //show All users
    if (id == 2) {
      return FutureBuilder(
        future: FirebaseFirestore.instance.collection("Users").get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFF093125),
              ),
            );
          } else if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            final users =
            docs.map((doc) => UserModel.fromJson(doc.data())).toList();
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Color(0xFFF5F9F7)],
                ),
              ),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF093125).withOpacity(0.08),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Color(0xFF093125).withOpacity(0.1),
                                    width: 1,
                                  ),
                                  color: Color(0xFF093125).withOpacity(0.05),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(11),
                                  child: user.profileImageUrl.isNotEmpty
                                      ? Image.network(
                                    user.profileImageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Center(
                                          child: Icon(
                                            Icons.person,
                                            color: Color(0xFF093125),
                                            size: 40,
                                          ),
                                        ),
                                  )
                                      : Center(
                                    child: Icon(
                                      Icons.person,
                                      color: Color(0xFF093125),
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            user.name,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF093125),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: user.admin
                                                ? Color(0xFFEAF9D9)
                                                : Colors.grey[100],
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(
                                              color: user.admin
                                                  ? Color(0xFFA8ED4F)
                                                  : Colors.grey[300]!,
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            user.admin ? "Admin" : "User",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: user.admin
                                                  ? Color(0xFF093125)
                                                  : Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    _buildUserInfoRow(
                                      Icons.email_outlined,
                                      user.email,
                                    ),
                                    SizedBox(height: 6),
                                    _buildUserInfoRow(
                                      Icons.phone_outlined,
                                      user.phoneNumber,
                                    ),
                                    SizedBox(height: 6),
                                    _buildUserInfoRow(
                                      Icons.location_on_outlined,
                                      user.address,
                                    ),
                                    SizedBox(height: 6),
                                    _buildUserInfoRow(
                                      Icons.calendar_today_outlined,
                                      "Joined: ${user.createdAt.toLocal().toString().split(' ')[0]}",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off_outlined,
                    size: 64,
                    color: Color(0xFF093125).withOpacity(0.3),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No users found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF093125),
                    ),
                  ),
                ],
              ),
            );
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
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFF093125),
              ),
            );
          } else if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            final products =
            docs.map((doc) => Product.fromFirestore(doc)).toList();
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Color(0xFFF5F9F7)],
                ),
              ),
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final docId = docs[index].id;

                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF093125).withOpacity(0.08),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Container(
                            height: 160,
                            width: double.infinity,
                          //  color: Color(0xFF093125).withOpacity(0.05),
                            color: Colors.white,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  product.imageUrl ?? '',
                                  fit: BoxFit.fitHeight,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          color: Color(0xFF093125).withOpacity(0.3),
                                          size: 40,
                                        ),
                                      ),
                                ),
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(product.status),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      product.status.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: _getStatusTextColor(product.status),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      product.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF093125),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEAF9D9),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      "৳${product.currentPrice}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF093125),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                product.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F9F7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    _buildProductInfoRow(
                                      Icons.person_outline,
                                      "Seller",
                                      product.sellerName,
                                    ),
                                    SizedBox(height: 8),
                                    _buildProductInfoRow(
                                      Icons.emoji_events_outlined,
                                      "Top Bidder",
                                      product.highBidderName,
                                    ),
                                   SizedBox(height: 8),
                                    _buildProductInfoRow(
                                      Icons.calendar_today_outlined,
                                      "Ends",
                                      product.auctionEndTime
                                          .toLocal()
                                          .toString()
                                          .split(' ')[0],
                                    ),
                                    if(product.status=='ended') SizedBox(height: 8),
                                    if(product.status=='ended')  _buildProductInfoRow(
                                      Icons.calendar_today_outlined,
                                      "Payment Status",
                                      product.paid.toString(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if(product.status=='ended' && product.paid==false)    Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Color(0xff093125),),
                                      color: Colors.red.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.payment,
                                        color: Color(0xff093125),
                                        size: 20,
                                      ),
                                      onPressed: () async {
                                      await FirebaseFirestore.instance.collection("products").doc(product.productId).update({
                                        "paid": true
                                      });
                                      },
                                      tooltip: "Send notification",
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Color(0xff093125),),
                                      //color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.send,
                                        color: Color(0xff093125),
                                        size: 20,
                                      ),
                                      onPressed: () async {
                                        final winner = await FirebaseFirestore
                                            .instance
                                            .collection("Users")
                                            .doc(product.highBidderId)
                                            .get();
                                        final fcm = winner.get("fcmToken");
                                        print(fcm);
                                        FirebaseApi().sendNotification(
                                          fcm,
                                          "Congratulations",
                                          "You have won the auction for ${product.name}",
                                        );
                                      },
                                      tooltip: "Send notification",
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xff093125),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                              "Delete Product",
                                              style: TextStyle(
                                                color: Color(0xFF093125),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            content: Text(
                                              "Are you sure you want to delete this product?",
                                              style: TextStyle(
                                                color: Color(0xFF093125).withOpacity(0.8),
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context, false),
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    color: Color(0xFF093125),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context, true),
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
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
                                            final imageRef = FirebaseStorage.instance
                                                .refFromURL(product.imageUrl);
                                            await imageRef.delete();

                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Product deleted'),
                                                backgroundColor: Color(0xFF093125),
                                              ),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Failed to delete product'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      tooltip: "Delete product",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Color(0xFF093125).withOpacity(0.3),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No products found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF093125),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      );
    }

//show all requests
    if (id == 4) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("request").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFF093125),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.withOpacity(0.5),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Error: ${snapshot.error}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Color(0xFF093125).withOpacity(0.3),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No requests found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF093125),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            final products =
            docs.map((doc) => Product.fromFirestore(doc)).toList();
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Color(0xFFF5F9F7)],
                ),
              ),
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF093125).withOpacity(0.08),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Container(
                            height: 160,
                            width: double.infinity,
                            color: Colors.white,
                            child: Image.network(
                              product.imageUrl ?? '',
                              fit: BoxFit.fitHeight,
                              errorBuilder: (context, error, stackTrace) => Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Color(0xFF093125).withOpacity(0.3),
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF093125),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Description",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color:  Color(0xff093125),),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.done,
                                        color: Color(0xff093125),
                                        weight: 2,
                                        size: 25,
                                      ),
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection("products")
                                            .doc(product.productId)
                                            .set(product.toMap());
                                        await FirebaseFirestore.instance
                                            .collection("request")
                                            .doc(product.productId)
                                            .delete();

                                      },
                                      tooltip: "Accept",
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xff093125),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection("request")
                                            .doc(product.productId)
                                            .delete();
                                         },
                                      tooltip: "Reject",
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F9F7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    _buildProductInfoRow(
                                      Icons.person_outline,
                                      "Seller",
                                      product.sellerName,
                                    ),
                                    SizedBox(height: 8),
                                    _buildProductInfoRow(
                                      Icons.attach_money,
                                      "Price",
                                      "৳${product.currentPrice}",
                                    ),
                                    SizedBox(height: 8),
                                    _buildProductInfoRow(
                                      Icons.calendar_today_outlined,
                                      "Ends",
                                      product.auctionEndTime
                                          .toLocal()
                                          .toString()
                                          .split(' ')[0],
                                    ),
                                    SizedBox(height: 8),
                                    _buildProductInfoRow(
                                      Icons.info_outline,
                                      "Status",
                                      product.status,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(child: Text("No products found."));
          }
        },
      );
    }

    if (id == 5) {
      // Empty block
    }

// show all item storage
    if (id == 6) {
      return FutureBuilder(
        future: FirebaseStorage.instance.ref('itemPhoto/').listAll(),
        builder: (context, AsyncSnapshot<ListResult> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFF093125),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.items.isNotEmpty) {
            final items = snapshot.data!.items;

            return FutureBuilder(
              future: Future.wait(items.map((ref) async {
                final url = await ref.getDownloadURL();
                return {'ref': ref, 'url': url};
              })),
              builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> urlSnapshot) {
                if (urlSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF093125),
                    ),
                  );
                } else if (urlSnapshot.hasData) {
                  final imageEntries = urlSnapshot.data!;

                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Color(0xFFF5F9F7)],
                      ),
                    ),
                    child: GridView.builder(
                      padding: EdgeInsets.all(16),
                      shrinkWrap: true,
                      itemCount: imageEntries.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final imageEntry = imageEntries[index];
                        final imageUrl = imageEntry['url'];
                        final imageRef = imageEntry['ref'] as Reference;

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF093125).withOpacity(0.08),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: Color(0xFF093125).withOpacity(0.05),
                                    child: Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Color(0xFF093125).withOpacity(0.3),
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                              "Delete Image",
                                              style: TextStyle(
                                                color: Color(0xFF093125),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            content: Text(
                                              "Are you sure you want to delete this image?",
                                              style: TextStyle(
                                                color: Color(0xFF093125).withOpacity(0.8),
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context, false),
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    color: Color(0xFF093125),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context, true),
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm == true) {
                                          await imageRef.delete();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Image deleted'),
                                              backgroundColor: Color(0xFF093125),
                                            ),
                                          );
                                          // Refresh UI after deletion
                                          (context as Element).markNeedsBuild();
                                        }
                                      },
                                      tooltip: "Delete image",
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.7),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                    child: Text(
                                      imageRef.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      "Failed to load image URLs.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF093125),
                      ),
                    ),
                  );
                }
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 64,
                    color: Color(0xFF093125).withOpacity(0.3),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No photos found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF093125),
                    ),
                  ),
                ],
              ),
            );
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
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFF093125),
              ),
            );
          }

          if (!roomSnapshot.hasData || roomSnapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.meeting_room_outlined,
                    size: 64,
                    color: Color(0xFF093125).withOpacity(0.3),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No private rooms found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF093125),
                    ),
                  ),
                ],
              ),
            );
          }

          final rooms = roomSnapshot.data!.docs;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFFF5F9F7)],
              ),
            ),
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: rooms.length,
              itemBuilder: (context, roomIndex) {
                final room = rooms[roomIndex];
                final roomId = room.id;

                return Container(
                  margin: EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF093125).withOpacity(0.08),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF093125),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.vpn_key_outlined,
                              color: Color(0xFFA8ED4F),
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Room ID: $roomId",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("private rooms")
                            .doc(roomId)
                            .collection("products")
                            .get(),
                        builder: (context, productSnapshot) {
                          if (productSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              height: 100,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF093125),
                                ),
                              ),
                            );
                          }

                          if (!productSnapshot.hasData ||
                              productSnapshot.data!.docs.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.inventory_2_outlined,
                                      size: 48,
                                      color: Color(0xFF093125).withOpacity(0.3),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      "No products in this room",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF093125),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
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

                              return Container(
                                margin: EdgeInsets.fromLTRB(16, 16, 16, index == products.length - 1 ? 16 : 0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F9F7),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Color(0xFF093125).withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(11),
                                        topRight: Radius.circular(11),
                                      ),
                                      child: Container(
                                        height: 140,
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: Image.network(
                                          product.imageUrl ?? '',
                                          fit: BoxFit.fitHeight,
                                          errorBuilder: (context, error, stackTrace) =>
                                              Center(
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color: Color(0xFF093125).withOpacity(0.3),
                                                  size: 40,
                                                ),
                                              ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  product.name,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF093125),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFEAF9D9),
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                child: Text(
                                                  "৳${product.currentPrice}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF093125),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            product.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Divider(
                                            color: Color(0xFF093125).withOpacity(0.1),
                                          ),
                                          SizedBox(height: 12),
                                          _buildProductInfoRow(
                                            Icons.person_outline,
                                            "Seller",
                                            product.sellerName,
                                          ),
                                          SizedBox(height: 8),
                                          _buildProductInfoRow(
                                            Icons.emoji_events_outlined,
                                            "Top Bidder",
                                            product.highBidderName,
                                          ),
                                          SizedBox(height: 8),
                                          _buildProductInfoRow(
                                            Icons.calendar_today_outlined,
                                            "Ends",
                                            product.auctionEndTime
                                                .toLocal()
                                                .toString()
                                                .split(' ')[0],
                                          ),
                                          SizedBox(height: 8),
                                          _buildProductInfoRow(
                                            Icons.info_outline,
                                            "Status",
                                            product.status,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      );
    }

// delivery request
    if (id == 8) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("paid", isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFF093125),
              ),
            );
          } else if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            final products = docs.map((doc) => Product.fromFirestore(doc)).toList();

            if (products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_shipping_outlined,
                      size: 64,
                      color: Color(0xFF093125).withOpacity(0.3),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "No delivery requests",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF093125),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Color(0xFFF5F9F7)],
                ),
              ),
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final buyerId = product.highBidderId;

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(buyerId)
                        .get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF093125).withOpacity(0.08),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF093125),
                            ),
                          ),
                        );
                      }

                      final data =
                          userSnapshot.data?.data() as Map<String, dynamic>? ?? {};
                      final address = data['address'] ?? 'Address not available';

                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF093125).withOpacity(0.08),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  child: Container(
                                    height: 160,
                                    width: double.infinity,
                                    color: Colors.white,
                                    child: Image.network(
                                      product.imageUrl ?? '',
                                      fit: BoxFit.fitHeight,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Center(
                                            child: Icon(
                                              Icons.image_not_supported,
                                              color: Color(0xFF093125).withOpacity(0.3),
                                              size: 40,
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFA8ED4F),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Color(0xFF093125),
                                          size: 16,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "PAID",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF093125),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          product.name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF093125),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFEAF9D9),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: Text(
                                          "৳${product.currentPrice}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF093125),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    product.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF5F9F7),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Color(0xFF093125).withOpacity(0.1),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Delivery Information",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF093125),
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        _buildDeliveryInfoRow(
                                          Icons.person_outline,
                                          "Seller",
                                          product.sellerName,
                                        ),
                                        SizedBox(height: 8),
                                        _buildDeliveryInfoRow(
                                          Icons.person_outline,
                                          "Buyer",
                                          product.highBidderName,
                                        ),
                                        SizedBox(height: 8),
                                        _buildDeliveryInfoRow(
                                          Icons.location_on_outlined,
                                          "Delivery Address",
                                          address,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Container(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        // Handle delivery action
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Delivery initiated'),
                                            backgroundColor: Color(0xFF093125),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.local_shipping_outlined,
                                        size: 20,
                                      ),
                                      label: Text(
                                        "Process Delivery",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF093125),
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.withOpacity(0.5),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No products found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffbfbfb),
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
        //  crossAxisAlignment: CrossAxisAlignment.start,
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

            Expanded(
              child: ListView(
                children: [
                  //const Divider(height: 32, thickness: 0.5),
                  SizedBox(
                    height: 20,
                  ),
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



  void monitorEndNotification() async{


    _timerNoti= Timer.periodic(Duration(seconds: 1), (timer) async{

      QuerySnapshot auctions = await FirebaseFirestore.instance
          .collection('products')
          .where('status', isEqualTo: 'ended')
          .get();


      for (var auction in auctions.docs) {
        if(auction['notified']!=true){

          final winner =await FirebaseFirestore.instance.collection("Users").doc(auction['highBidderId']).get();
          final fcm = winner.get("fcmToken");
          FirebaseApi().sendNotification(fcm,"Congratulations","You have won the auction for ${auction['name']}");
          await auction.reference.update({'notified': true});
        }

      }
    });
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