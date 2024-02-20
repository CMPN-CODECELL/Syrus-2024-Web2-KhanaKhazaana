import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ReminderService {
  bool _isNotificationSent = false;

  void showLocationShareNotification() {
    if (!_isNotificationSent) {
      // Show the notification
      print('Notification: Share your location with emergency contacts');
      _isNotificationSent = true;

      // Schedule a timer to reset the flag after an hour
      Timer(Duration(hours: 1), () {
        _isNotificationSent = false;
      });
    }
  }

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initNotifications() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showReminderNotification(
      {required String reminderMessage}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'reminder_channel',
      'Reminder',
      channelDescription: reminderMessage,
      importance: Importance.high,
      priority: Priority.high,
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notificationsPlugin.show(
      0,
      'Reminder',
      reminderMessage,
      platformChannelSpecifics,
    );
  }

  void sendLocationNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'reminder_channel',
      'Reminder',
      channelDescription: 'Share your location with emergency contacts.',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notificationsPlugin.show(
      0,
      'Share Location',
      'Tap to share your location with emergency contacts.',
      platformChannelSpecifics,
    );
  }

  late Timer _timer;
  void scheduleNotifications() {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'location_notification_channel',
      'Location Notification',
      channelDescription:
          'Notify to share your location with emergency contacts',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    _timer = Timer.periodic(Duration(hours: 1), (Timer timer) {
      _showNotification(platformChannelSpecifics);
    });
  }

  Future<void> _showNotification(
      NotificationDetails notificationDetails) async {
    await _notificationsPlugin.show(
      0,
      'Share your location with emergency contacts',
      'It has been an hour since you last shared your location. Please share your current location with your emergency contacts.',
      notificationDetails,
    );
  }
}
