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
    return RefreshIndicator(
      onRefresh: ()async{
        await Future.delayed(Duration(seconds: 0));
        setState(() {

        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Profile"),
        ),
        body: Center(
          child: FutureBuilder<DocumentSnapshot>(future: FirebaseFirestore.instance.collection("Users").doc(widget.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    child: CircularProgressIndicator(), // Show a loading indicator
                  );
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text("No Data");
                }


                UserModel user= UserModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                  return ListView(
                    padding: EdgeInsets.all(20),
                    scrollDirection: Axis.vertical,
                    children: [
                      SizedBox(height: 20,),
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: user.profileImageUrl!="" ? NetworkImage(user.profileImageUrl):null,
                        backgroundColor: Colors.grey[300],
                        child: (user.profileImageUrl == "" )
                            ? Icon(Icons.person, size: 70, color: Colors.white)
                            : null,
                      ),
                      SizedBox(height: 20,),
                      Text("Name: ${user.name}"),
                      SizedBox(height: 20,),
                      Text("Email: ${user.email}"),
                      SizedBox(height: 20,),
                      Text("Phone Number: ${user.phoneNumber}"),
                      SizedBox(height: 20,),
                      Text("Address: ${user.address}"),
                      SizedBox(height: 20,),
                      outlinedButton(text: "Show My Products",
                      //  icon: Icons.login,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => showMyItems(),));
                        },
                      //  color: Colors.green,
                      //  textColor: Colors.white,
                )

                    ],
                  );

              },),
      )
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
                    ElevatedButton(
                      onPressed: () {
                        final id= DateTime.parse(product.productId);
                        onButtonTap('bkash',context,product.currentPrice,id.millisecondsSinceEpoch.toString());
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => Checkout(),));
                      },
                      child: Text('Pay now', style: TextStyle(color: Colors.white,fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      )
    );
  }
}
