import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:live_streams_app/features/live_stream/view/live_stream_page.dart';
import 'package:live_streams_app/features/personal_informations/personal_informations.dart';
import 'package:live_streams_app/features/verify/view/verify_page.dart';

import '../main.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const IOSInitializationSettings iOS = IOSInitializationSettings();
    var initSetttings =
        const InitializationSettings(android: android, iOS: iOS);

    _notificationsPlugin.initialize(initSetttings,
        onSelectNotification: (String? payload) {
      final Map<String, dynamic> data = jsonDecode(payload!);
      final String route = data['route'];
      if (route == 'verify') {
        Navigator.of(navigatorKey.currentState!.context)
            .push<void>(VerifyPage.route(data['id']));
      } else if (route == 'live_stream') {
        Navigator.of(navigatorKey.currentState!.context)
            .push<void>(LiveStreamPage.route());
      } else if (route == 'personal_information') {
        Navigator.of(navigatorKey.currentState!.context)
            .push<void>(PersonalInformationsPage.route());
      }
    });
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('liveStreamApp', 'liveStreamApp Channel',
              channelDescription: 'This is liveStreamApp Channel',
              playSound: false,
              importance: Importance.max,
              priority: Priority.high);

      const IOSNotificationDetails iOSPlatformChannelSpecifics =
          IOSNotificationDetails(presentSound: true);
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      final Map<String, dynamic> payload = {
        'id': message.data['id'],
        'route': message.data['route']
      };

      await _notificationsPlugin.show(id, message.notification!.title,
          message.notification!.body, platformChannelSpecifics,
          payload: jsonEncode(payload));
    } on Exception catch (_) {}
  }
}
