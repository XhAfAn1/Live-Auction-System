import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liveauctionsystem/home/homepage.dart';
import 'package:liveauctionsystem/login%20signup/login.dart';

class wrapper extends StatefulWidget {
  const wrapper({super.key, User? initialUser});

  @override
  State<wrapper> createState() => _wrapperState();
}

class _wrapperState extends State<wrapper> {
 
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      // 🔹 Correct Stream
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Loading indicator
        }
        if (snapshot.hasData) {
          return HomePage(); // If logged in, go to HomePage
        } else {
          return login(); // If logged out, go to Login page
        }
      },
    );
  }
}