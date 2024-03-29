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
    apiKey: 'AIzaSyDbUy1AKhQP9R9ohi7sb_QMQ4CK8flHEF8',
    appId: '1:627148347748:web:47e1cc279776ead5290271',
    messagingSenderId: '627148347748',
    projectId: 'panitik-bf107',
    authDomain: 'panitik-bf107.firebaseapp.com',
    storageBucket: 'panitik-bf107.appspot.com',
    measurementId: 'G-T5N3M4W411',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyACdJ0GapN45yuohW0WPmMSW2fnbCZrEwU',
    appId: '1:627148347748:android:95d4bab4078474e6290271',
    messagingSenderId: '627148347748',
    projectId: 'panitik-bf107',
    storageBucket: 'panitik-bf107.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCm3xm1pPhIopCNMpkYhs--rt9N37NM3zo',
    appId: '1:627148347748:ios:7bfed95d22cd7ba0290271',
    messagingSenderId: '627148347748',
    projectId: 'panitik-bf107',
    storageBucket: 'panitik-bf107.appspot.com',
    iosBundleId: 'com.example.panitik',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCm3xm1pPhIopCNMpkYhs--rt9N37NM3zo',
    appId: '1:627148347748:ios:4904674b3bde8165290271',
    messagingSenderId: '627148347748',
    projectId: 'panitik-bf107',
    storageBucket: 'panitik-bf107.appspot.com',
    iosBundleId: 'com.example.panitik.RunnerTests',
  );
}
