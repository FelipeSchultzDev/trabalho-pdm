// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCAJh5CuRpshrTQXXKSYPcIlTpyZaIrHHs',
    appId: '1:800483594728:web:1784062d801aa93088545d',
    messagingSenderId: '800483594728',
    projectId: 'zap-zap-96539',
    authDomain: 'zap-zap-96539.firebaseapp.com',
    storageBucket: 'zap-zap-96539.appspot.com',
    measurementId: 'G-B0J9FX787J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCy_bRVpvYuLHduIEmlOYfNw-Xyr4IVsDU',
    appId: '1:800483594728:android:4d9ded6d714809c088545d',
    messagingSenderId: '800483594728',
    projectId: 'zap-zap-96539',
    storageBucket: 'zap-zap-96539.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAGBmMpp-TqtYjm_xQuTo5wNicmnwABwJI',
    appId: '1:800483594728:ios:549464b3a0b6ced788545d',
    messagingSenderId: '800483594728',
    projectId: 'zap-zap-96539',
    storageBucket: 'zap-zap-96539.appspot.com',
    iosBundleId: 'com.example.projetoFinal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAGBmMpp-TqtYjm_xQuTo5wNicmnwABwJI',
    appId: '1:800483594728:ios:eeb6ae4427d7126c88545d',
    messagingSenderId: '800483594728',
    projectId: 'zap-zap-96539',
    storageBucket: 'zap-zap-96539.appspot.com',
    iosBundleId: 'com.example.projetoFinal.RunnerTests',
  );
}