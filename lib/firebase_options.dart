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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyD0qUHBPLne9sPHscEmi1QcH4CLG6LStkc',
    appId: '1:785010256037:web:47e84f60a3bcf404a6854c',
    messagingSenderId: '785010256037',
    projectId: 'online-shop-80746',
    authDomain: 'online-shop-80746.firebaseapp.com',
    storageBucket: 'online-shop-80746.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA00lrEz3XjCJBJOt5jWyG2GIIuQpjJQHE',
    appId: '1:785010256037:android:b2caddbd455d9a25a6854c',
    messagingSenderId: '785010256037',
    projectId: 'online-shop-80746',
    storageBucket: 'online-shop-80746.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBF7zqxKSrESSrj6JPltqsgbjHBIxAW6mM',
    appId: '1:785010256037:ios:f39b66e5a61f2b81a6854c',
    messagingSenderId: '785010256037',
    projectId: 'online-shop-80746',
    storageBucket: 'online-shop-80746.firebasestorage.app',
    iosBundleId: 'com.example.onlineShopping',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBF7zqxKSrESSrj6JPltqsgbjHBIxAW6mM',
    appId: '1:785010256037:ios:f39b66e5a61f2b81a6854c',
    messagingSenderId: '785010256037',
    projectId: 'online-shop-80746',
    storageBucket: 'online-shop-80746.firebasestorage.app',
    iosBundleId: 'com.example.onlineShopping',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD0qUHBPLne9sPHscEmi1QcH4CLG6LStkc',
    appId: '1:785010256037:web:bf6e894d7a12e958a6854c',
    messagingSenderId: '785010256037',
    projectId: 'online-shop-80746',
    authDomain: 'online-shop-80746.firebaseapp.com',
    storageBucket: 'online-shop-80746.firebasestorage.app',
  );
}
