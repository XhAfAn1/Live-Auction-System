// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDfDMfxcdAt44_r2gyYJ5pNGxSzD8mtYh8',
    appId: '1:443378336257:web:e17b2b0b25099b58d3b600',
    messagingSenderId: '443378336257',
    projectId: 'live-auction-system-26b33',
    authDomain: 'live-auction-system-26b33.firebaseapp.com',
    storageBucket: 'live-auction-system-26b33.firebasestorage.app',
    measurementId: 'G-0X852P6P15',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD_wxXz-UgLmP_ZaE6ZwCKl9GoKFvhRQTU',
    appId: '1:443378336257:android:aa14309f688a60dbd3b600',
    messagingSenderId: '443378336257',
    projectId: 'live-auction-system-26b33',
    storageBucket: 'live-auction-system-26b33.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDfDMfxcdAt44_r2gyYJ5pNGxSzD8mtYh8',
    appId: '1:443378336257:web:73eb350281e91098d3b600',
    messagingSenderId: '443378336257',
    projectId: 'live-auction-system-26b33',
    authDomain: 'live-auction-system-26b33.firebaseapp.com',
    storageBucket: 'live-auction-system-26b33.firebasestorage.app',
    measurementId: 'G-Z36BRH0G5M',
  );

}