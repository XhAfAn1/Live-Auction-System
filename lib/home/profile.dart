import 'package:bkash/bkash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../classes/Product.dart';
import '../classes/user.dart';
import '../custom stuffs/buttons.dart';
import '../main.dart';
import '../payment/checkout.dart';
import '../payment/payment_helper.dart';

class profile extends StatefulWidget {
final String uid;
  const profile({super.key, required this.uid});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text("Profile", style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 200));
          setState(() {});
        },
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection("Users").doc(widget.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text("No Data"));
            }

            UserModel user = UserModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);

            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                SizedBox(height: 20),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: user.profileImageUrl != "" ? NetworkImage(user.profileImageUrl) : null,
                        child: user.profileImageUrl == ""
                            ? Icon(Icons.person, size: 60, color: Colors.white)
                            : null,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildInfoRow("Name", user.name),
                        buildInfoRow("Email", user.email),
                        buildInfoRow("Phone", user.phoneNumber),
                        buildInfoRow("Address", user.address),
                        buildInfoRow("User ID", user.id),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                if(!user.admin)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.inventory),
                    label: Text("Show My Products"),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => showMyItems()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              )),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}


class showMyItems extends StatelessWidget {
  const showMyItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("My Items"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where("status", isEqualTo: "ended")
            .where("highBidderId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No products available.'));
          }

          final products = snapshot.data!.docs.map((doc) => Product.fromFirestore(doc)).toList();

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black.withAlpha(40), width: 2),
                ),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(product.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 100,
                      width: 100,
                    ),
                    Column(
                      //  crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Title: ${product.name}', style: TextStyle(fontSize: 6)),

                      ],
                    ),
                    (!product.paid) ?
                    ElevatedButton(
                      onPressed: () {
                        final id= DateTime.parse(product.productId);
                        //onButtonTap('bkash',context,product.currentPrice,id.millisecondsSinceEpoch.toString());
                        bkashPayment(context,product.currentPrice,id.millisecondsSinceEpoch.toString());
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => Checkout(),));
                      },
                      child: Text('Pay now', style: TextStyle(color: Colors.white,fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 40),
                        maximumSize:Size(100, 40),
                        backgroundColor: Color(0xff0a3a0b),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ):
                    ElevatedButton(
                      onPressed: null,
                      child: Text('Paid', style: TextStyle(color: Color(0xff0a3a0b),fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: Colors.white,
                        backgroundColor: Colors.white,
                        minimumSize: Size(100, 40),
                        maximumSize:Size(100, 40) ,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),side: BorderSide(width:1,color: Color(0xff0a3a0b))),
                      ),
                    )
                    ,
                  ],
                ),
              );
            },
          );
        },
      )
    );
  }

  bkashPayment(context,int totalPrice,String name) async {
    final bkash = Bkash(
      // bkashCredentials: BkashCredentials(username: username, password: password, appKey: appKey, appSecret: appSecret),
      logResponse: true,
    );

    try {
      final response = await bkash.pay(
          context: context,
          amount: totalPrice.toDouble(),
          merchantInvoiceNumber: '$name',
          payerReference: 'Aucsy00$name'
      );

      print(response.trxId);
      print(response.paymentId);
    } on BkashFailure catch (e) {
      print(e.message);
    }
  }
}
