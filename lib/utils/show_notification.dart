import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todolist_app/helpers/notifications_helper.dart';

Future<void> showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'message_channel',
    'retods_app',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  const NotificationDetails platformChannelSpesifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
      0, 'Alarm', 'Todo Expirated', platformChannelSpesifics,
      payload: 'Alarm triggered');
}
