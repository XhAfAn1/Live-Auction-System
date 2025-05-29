import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:liveauctionsystem/app datas/theme data.dart';
import 'package:liveauctionsystem/home/homepage.dart';
import 'package:liveauctionsystem/home/private%20bidding/private%20room.dart';
import 'package:liveauctionsystem/wrapper.dart';
import 'firebase/firebase message api.dart';
import 'firebase/firebase_options.dart';
import 'login signup/login.dart';

bool get isSkiaWeb => kIsWeb;

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Background message received: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final firebaseApi = FirebaseApi();
  if (!isSkiaWeb && !(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    await firebaseApi.initNotifications();
  }

  runApp(MyApp());
}

Timer? _timer;
class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Poppins',colorScheme: ColorScheme(brightness: Brightness.light, primary: Color(0xffabd14c), onPrimary: Colors.white, secondary: Colors.white, onSecondary: Colors.white, error: Colors.red, onError: Colors.red, surface: Colors.white, onSurface: Colors.black87)),
      debugShowCheckedModeBanner: false,
    //  theme: ThemeData(colorScheme: LightDarkMode.dark),
      home: Wrapper(), // Pass initial user to wrapper
     // home: private_room(), // Pass initial user to wrapper
    );
  }
}




void monitorAuctionStatus() async{


 _timer= Timer.periodic(Duration(seconds: 1), (timer) async{

    QuerySnapshot auctions = await FirebaseFirestore.instance
        .collection('products')
        .where('status', isNotEqualTo: 'ended')
        .get();
    DateTime now = DateTime.now();


    for (var auction in auctions.docs) {
      DateTime endTime = DateTime.parse(auction['auctionEndTime']);

      DateTime startTime = DateTime.parse(auction['auctionStartTime']);


      if(now.isAfter(startTime) && auction['status'] != 'active'){
        print('hi');
        print('${auction['name']} ${auction['status']}');
        await auction.reference.update({'status': 'active'});
      }

      // Check if the auction has ended
      if (now.isAfter(endTime) && auction['status'] != 'ended') {
        await auction.reference.update({'status': 'ended'});

      }


    }
  });
}
void stopMonitoring() {
  _timer?.cancel();
}


showLogDiag(context){
  showDialog(context: context,
    builder: (context) =>
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orangeAccent,
                size: 50, // Large warning icon
              ),
              const SizedBox(height: 10),
              Text(
                'You are not logged in',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: Text(
            'Please log in to access this feature.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0a3a0b),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => login()),
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(color: Colors.grey.shade400),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ],
        ),
  );



}