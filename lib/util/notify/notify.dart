import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:advcal/model/db/todo_db.dart';
import 'package:flutter/material.dart';
import 'package:advcal/model/shared/shared.dart';

void initial_notyfy() => AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'Todo_channel_group',
            channelKey: 'Todo_channel',
            channelName: 'Todo notifications',
            channelDescription: 'Notification channel for Todo',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white),
        // Channel groups are only visual and are not required
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'Todo_channel_group',
            channelGroupName: 'Todo group')
      ],
      debug: true,
    );

void make_notify(int id, String title, String body, DateTime date) =>
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: id, channelKey: 'Todo_channel', title: title, body: body),
      schedule: NotificationCalendar.fromDate(date: date),
    );

void make_notify_all() async {
  final db = MyDatabase();
  final items = await db.readAllTodoData();
  int decrease = await getNotifySetting();

  items.forEach((item) {
    if (item.limitDate != null && item.isNotify) {
      make_notify(item.id, item.title, item.description,
          item.limitDate!.add(Duration(hours: -decrease)));
    }
  });
}

void start_listen(BuildContext context) => AwesomeNotifications()
    .actionStream
    .listen((ReceivedNotification receivedNotification) {});
