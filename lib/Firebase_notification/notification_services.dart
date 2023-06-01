import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer' as devtools show log;

import 'package:http/http.dart';

class LocalNotificationServices {
  static String serverKey =
      'AAAAMhEcL2c:APA91bEIRJRFIvaY2NqGHt6gi-nSekNWcwbGVmiBvxcrzY_IX8m4gzk8XCMXiIEqi4Rj4TSgY2EkXbMgvd81W3RPo6jBK4JlNlgf_fo4Bd0hEnrpb6xjvyo3FtVm4Np8Zj3kozq3pl4V';
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static void initialize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'));

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Display remote message
  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        'myChanel',
        'my Chanel',
        priority: Priority.high,
        importance: Importance.max,
      ));

      await _flutterLocalNotificationsPlugin.show(
          id,
          message.notification?.title,
          message.notification?.body,
          notificationDetails);
    } on Exception catch (e) {
      devtools.log('Exception comming from LocalNotifcation Class $e');
      // TODO
    }
  }

  // Api call to sen notification
  static Future<void> sendNotification(
      String tittle, String message, String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_click',
      'id': '1',
      'status': 'done',
      'message': message
    };

    Response response = await post(
        Uri.parse(
          'https://fcm.googleapis.com/fcm/send',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey'
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{'body': message, 'title': tittle},
          'priority': 'high',
          'data': data,
          'to': token
        }));
    devtools.log(
        'response comming from notification class :: ${response.statusCode}');
  }
  //

//user group mwssage---------------------
  // Api call to sen notification
  static Future<void> sendGroupNotification(
    List members,
    String tittle,
    String message,
  ) async {
    for (int i = 0; i < members.length; i++) {
      Response response = await post(
          Uri.parse(
            'https://fcm.googleapis.com/fcm/send',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey'
          },
          body: jsonEncode(<String, dynamic>{
            'notification': <String, dynamic>{'body': message, 'title': tittle},
            'priority': 'high',
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_click',
              'id': '1',
              'status': 'done',
              'message': message
            },
            'to': members[i]
          }));
      devtools.log(
          'response comming from Group notification class :: ${response.statusCode} ::::fcm: ${members[i]}');
    }
  }

// store token

  static storeTokenFun({String? uName, String? uId}) async {
    String? token = await FirebaseMessaging.instance.getToken();
    devtools.log('Token coming from firebaseStore token :: ${token}');
    FirebaseFirestore.instance.collection('user').doc(uId).set(
        {'fcmToken': token, 'email': uName, 'userRole': 'Admin'},
        SetOptions(merge: true));
  }
}
