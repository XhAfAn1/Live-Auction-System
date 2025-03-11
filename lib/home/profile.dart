import 'package:flutter/material.dart';

import '../classes/user.dart';

class profile extends StatelessWidget {
  final UserModel user;
  const profile({super.key,required this.user});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
        child: Text("Profile Page"),
    )
    );
  }
}
