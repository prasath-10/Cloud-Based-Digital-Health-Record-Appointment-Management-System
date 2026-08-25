// File generated for Firebase Initialization
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
        return ios;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA0KFDGwLdfbNSi13y3CpHxs_282JuCSMM',
    appId: '1:1047671216496:web:13bc9ceb7433',
    messagingSenderId: '1047671216496',
    projectId: 'migrant-clinic-hms',
    authDomain: 'migrant-clinic-hms.firebaseapp.com',
    storageBucket: 'migrant-clinic-hms.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA0KFDGwLdfbNSi13y3CpHxs_282JuCSMM',
    appId: '1:1047671216496:android:13bc9ceb7433',
    messagingSenderId: '1047671216496',
    projectId: 'migrant-clinic-hms',
    storageBucket: 'migrant-clinic-hms.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA0KFDGwLdfbNSi13y3CpHxs_282JuCSMM',
    appId: '1:1047671216496:ios:13bc9ceb7433',
    messagingSenderId: '1047671216496',
    projectId: 'migrant-clinic-hms',
    storageBucket: 'migrant-clinic-hms.appspot.com',
    iosBundleId: 'com.example.mobileApp',
  );
}
