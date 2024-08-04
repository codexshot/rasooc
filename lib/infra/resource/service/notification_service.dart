import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

NotificationService notificationService = NotificationService._();

class NotificationService {
  NotificationService._() {
    init();
  }
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final BehaviorSubject<ReceivedNotifications> didReceivedNotificationSubject =
      BehaviorSubject<ReceivedNotifications>();
  late InitializationSettings instializationSettings;

  Future<void> init() async {
    if (Platform.isIOS) {
      _requestPermission();
    }
    _initializePlatformSpecifics();
  }

  void _initializePlatformSpecifics() {
    final initalizationSettingAndroid =
        AndroidInitializationSettings('app_notif_icon');

    final initalizationSettingIos = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) async {
      final ReceivedNotifications receivedNotifications = ReceivedNotifications(
        id: id,
        title: title,
        body: body,
        payload: payload,
      );
      didReceivedNotificationSubject.add(receivedNotifications);
    });

    instializationSettings = InitializationSettings(
        android: initalizationSettingAndroid, iOS: initalizationSettingIos);
  }

  void _requestPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void setListenerForLowerVersions(Function onNotificaitonOnLowerVersion) {
    didReceivedNotificationSubject.listen((receivedNotification) {
      onNotificaitonOnLowerVersion(receivedNotification);
    });
  }

  Future<void> setNotificationOnClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(instializationSettings,
        onSelectNotification: (payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> showNotification() async {
    final androidNotificationSpecifics = AndroidNotificationDetails(
      "CHANNEL_ID",
      "CHANNEL_NAME",
      "CHANNEL_DESCRIPTION",
      importance: Importance.max,
      priority: Priority.high,
      timeoutAfter: 3000,
    );

    final iosNotificationSpecifics = IOSNotificationDetails();
    final platformNotiifcationSpecifics = NotificationDetails(
        android: androidNotificationSpecifics, iOS: iosNotificationSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      "Test Title",
      "Test body",
      platformNotiifcationSpecifics,
      payload: 'Test payload',
    );
  }

  Future<void> scehduleNotification(
      int id, String title, String body, String payLoad) async {
    final scheduleNotificationDateTime =
        DateTime.now().add(Duration(seconds: 5));

    final androidNotificationSpecifics = AndroidNotificationDetails(
      "CHANNEL_ID_SCHEDULE",
      "CHANNEL_NAME_SCHEDULE",
      "CHANNEL_DESCRIPTION",
      importance: Importance.max,
      priority: Priority.high,
      timeoutAfter: 3000,
    );

    final iosNotificationSpecifics = IOSNotificationDetails();
    final platformNotiifcationSpecifics = NotificationDetails(
        android: androidNotificationSpecifics, iOS: iosNotificationSpecifics);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformNotiifcationSpecifics,
      payload: payLoad,
    );
  }
}

class ReceivedNotifications {
  final int? id;
  final String? title;
  final String? body;
  final String? payload;

  ReceivedNotifications({
    this.id,
    this.title,
    this.body,
    this.payload,
  });
}
