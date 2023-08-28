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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCuYt5crU3sk29aADFtixE96T4wy2ontgY',
    appId: '1:1011970907113:web:d0f9d2cd0992989e92c978',
    messagingSenderId: '1011970907113',
    projectId: 'my-push-notifications-dcddb',
    authDomain: 'my-push-notifications-dcddb.firebaseapp.com',
    storageBucket: 'my-push-notifications-dcddb.appspot.com',
    measurementId: 'G-10XYW9BDRP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBTFfPVB530iqM97WOBfZvyQ-nfUSJZ48Q',
    appId: '1:1011970907113:android:1c02c914669aa15692c978',
    messagingSenderId: '1011970907113',
    projectId: 'my-push-notifications-dcddb',
    storageBucket: 'my-push-notifications-dcddb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDum6PqXwZKgN2lQHA1ChocbN-gtic7e7M',
    appId: '1:1011970907113:ios:2e2e4356d5c9bbb592c978',
    messagingSenderId: '1011970907113',
    projectId: 'my-push-notifications-dcddb',
    storageBucket: 'my-push-notifications-dcddb.appspot.com',
    iosClientId: '1011970907113-62pqsdkgja9naabo1jmadpgtj7f8p38b.apps.googleusercontent.com',
    iosBundleId: 'com.example.pushnotifications',
  );
}
