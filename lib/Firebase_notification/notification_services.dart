import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer' as devtools show log;

import 'package:http/http.dart';

  class LocalNotificationServices{
  static String serverKey = 'AAAAIexUAsY:APA91bEgk8WXoRUDfRdtk6OKT3njlBaaOfYQ_K20e0f6cY5iG9261SHAmqYc1VgiVOaqcttr2_C6dQj9xCcJiAfiWTpzetEKAiPXOYFRJVxi_5bD3oMk53KQKq83x0dvxnjoawvWv4jE';

  static  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
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

      await _flutterLocalNotificationsPlugin.show(id, message.notification?.title,
          message.notification?.body, notificationDetails);
    } on Exception catch (e) {
      devtools.log('Exception comming from LocalNotifcation Class $e');
      // TODO
    }
  }
  // Api call to sen notification
static Future<void> sendNotification (String tittle,String message,String token)async{

    final data = {
      'click_action' :'FLUTTER_NOTIFICATION_click',
      'id' : '1',
      'status' : 'done',
      'message' : message
    };

    Response response = await post(Uri.parse('https://fcm.googleapis.com/fcm/send',),
    headers: <String,String>{
      'Content-Type': 'application/json',
      'Authorization' : 'key=$serverKey'
    },
    body: jsonEncode(<String,dynamic>{
      'notification' : <String,dynamic>{'body' : message, 'title' : tittle},
      'priority' : 'high',
      'data' : data,
      'to' : token
    })
    );
    devtools.log('response comming from notification class :: ${response.statusCode}');

}
// store token

static storeTokenFun({String? uName, String? uId})async{
  String? token = await FirebaseMessaging.instance.getToken();
  devtools.log('Token coming from firebaseStore token :: ${token}');
  FirebaseFirestore.instance.collection('user').doc(uId).set({'fcmToken': token,'email': uName,'userRole': 'Admin'},SetOptions(merge: true));
}

}