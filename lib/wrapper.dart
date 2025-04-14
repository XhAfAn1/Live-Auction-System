import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liveauctionsystem/adminPanel/admin_panel.dart';
import 'package:liveauctionsystem/home/homepage.dart';
import 'package:liveauctionsystem/login signup/login.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold();
        }

        if (userSnapshot.hasData && userSnapshot.data != null) {
          final userId = userSnapshot.data!.uid;

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection("Users").doc(userId).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                return const Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(child: Text("User not found.")),
                );
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;
              final isAdmin = data['admin'] ?? false;

              if (isAdmin) {
                return const admin_panel();
              } else {
                return const HomePage();
              }
            },
          );
        } else {
          return const HomePage();
        }
      },
    );
  }
}
