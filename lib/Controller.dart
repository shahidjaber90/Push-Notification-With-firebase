import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:pushnotifications/Screen/signup.dart';

class MyPushNotification with ChangeNotifier {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final auth = FirebaseAuth.instance.currentUser!.email;
  String myToken = '';
  bool isLoading2 = false;

  // request permission
  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings setting = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (setting.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted permission');
    } else if (setting.authorizationStatus == AuthorizationStatus.provisional) {
      print('user granted provisional permission');
    } else {
      print('user decline or has not accepted permission');
    }
  }

  // get token
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      myToken = token!;
      notifyListeners();
      print('My Token:: $myToken');
      saveToken(myToken);
    });
  }

  // save token
  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection('UserTokens').doc(auth).set({
      'token': token,
    });
  }

  // send Notification
  void sendPushNotification(String token, String title, String body) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAA654qm-k:APA91bFHhQrv3gs7C-Hgolqq3XOl6eI072YNcmoXpj2Unen8lAxvOp8Y_06FTJ8HW8aYQlEpj2fix38czMgV8kcsKyYMSoJR0xXea9Q1o_wMIYPyWgpNRdJB7dID9jF0LiNBAx-a4720',
          },
          body: jsonEncode(<String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': token,
          }));
    } catch (e) {
      print('Catch Error:: ${e.toString()}');
    }
  }

  // send data
  void sendData(user, title, body) async {
    if (user != '') {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('UserTokens')
          .doc(user)
          .get();
      String token = snap['token'];
      print('token:: $token');
      sendPushNotification(token, title, body);
    }
  }
  //

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  // delete account

  Future<void> deleteUserAccount(context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    isLoading2 = true;
    notifyListeners();
    try {
      User? user = _auth.currentUser;
      DocumentReference docRef =
          firestore.collection('UserTokens').doc(user!.email);
      await docRef.delete();
      print('document deleted');

      if (user != null) {
        // Delete user account
        await user.delete();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SignUpView()));
        isLoading2 = false;
        notifyListeners();
      } else {
        print(user.phoneNumber);
        isLoading2 = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading2 = false;
      notifyListeners();
      print("Error deleting user account: $e");
    }
  }

  //
}
