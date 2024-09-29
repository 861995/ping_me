import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:we_chat/core/env/env.dart';

bool isLoggedIn = false;

class NotificationService {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/launcher_icon');

      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);

      await _localNotificationsPlugin.initialize(initializationSettings);
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');

        // _firebaseMessaging.onTokenRefresh.listen((newToken) {
        //   print("FCM Token refreshed: $newToken");
        // });
      } else {
        print('User declined or has not accepted permission');
      }
    } catch (e) {
      print("Error in initialize ${e}");
    }
  }

  void setupFCMListeners() {
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Received a message while app is in foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
          _showLocalNotification(message.notification!);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Message data: ${message.data}');
      });
    } catch (e) {
      print("Error in setupFCMListeners ${e}");
    }
  }

  Future<void> _showLocalNotification(RemoteNotification notification) async {
    try {
      if (notification.title != null && notification.body != null) {
        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        );
        const NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);

        await _localNotificationsPlugin.show(
          0,
          notification.title,
          notification.body,
          platformChannelSpecifics,
        );
      }
    } catch (e) {
      print("Error in _showLocalNotification ${e}");
    }
  }

  Future<void> sendNotification({
    required String recipientToken,
    required String title,
    required String body,
  }) async {
    try {
      String serverKey = Env.APP_SERVER_KEY;
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=${serverKey}',
        },
        body: jsonEncode({
          'notification': {
            'title': title,
            'body': body,
          },
          'priority': 'high',
          'to': recipientToken,
        }),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification. Error: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
