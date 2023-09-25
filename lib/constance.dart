import 'package:awesome_notifications/awesome_notifications.dart';

const kCalcMethodBox = 'calcMethod_box';

void makeNotificationForFajrPrayer({
  required DateTime dateTime,
  required int hour,
  required int minute,
  required String timeZone,
  required AwesomeNotifications awesomeNotifications,
}) {
  try {
    awesomeNotifications.createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(10000),
          channelKey: channelKey,
          title: 'New Notification',
          body: 'This is a new notification example for fajr time.',
          displayOnForeground: true,
          displayOnBackground: true,
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar(
          hour: hour,
          minute: minute,
          second: 0,
          day: dateTime.day,
          allowWhileIdle: true,
          timeZone: timeZone,
          preciseAlarm: true,
        ));
  } catch (error) {
    print(error.toString());
  }
}

void makeNotificationForDuhurPrayer(
    {required DateTime dateTime,
    required int hour,
    required int minute,
    required String timeZone,
    required AwesomeNotifications awesomeNotifications}) {
  try {
    awesomeNotifications.createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(10000),
          channelKey: channelKey,
          title: 'New Notification',
          body: 'This is a new notification example for fajr time.',
          displayOnForeground: true,
          displayOnBackground: true,
        ),
        schedule: NotificationCalendar(
          hour: hour,
          minute: minute,
          day: dateTime.day,
          second: 0,
          allowWhileIdle: true,
          timeZone: timeZone,
          preciseAlarm: true,
        ));
  } catch (error) {
    print(error.toString());
  }
}

void makeNotificationForAsrPrayer(
    {required DateTime dateTime,
    required int hour,
    required int minute,
    required String timeZone,
    required AwesomeNotifications awesomeNotifications}) {
  try {
    awesomeNotifications.createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(10000),
          channelKey: channelKey,
          title: 'New Notification',
          body: 'This is a new notification example for fajr time.',
          displayOnForeground: true,
          displayOnBackground: true,
        ),
        schedule: NotificationCalendar(
          hour: hour,
          minute: minute,
          day: dateTime.day,
          second: 0,
          allowWhileIdle: true,
          timeZone: timeZone,
          preciseAlarm: true,
        ));
  } catch (error) {
    print(error.toString());
  }
}

void makeNotificationForMaghribPrayer(
    {required DateTime dateTime,
    required int hour,
    required int minute,
    required String timeZone,
    required AwesomeNotifications awesomeNotifications}) {
  try {
    awesomeNotifications.createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(10000),
          channelKey: channelKey,
          title: 'New Notification',
          body: 'This is a new notification example for fajr time.',
          displayOnForeground: true,
          displayOnBackground: true,
        ),
        schedule: NotificationCalendar(
          hour: hour,
          minute: minute,
          day: dateTime.day,
          second: 0,
          allowWhileIdle: true,
          timeZone: timeZone,
          preciseAlarm: true,
        ));
  } catch (error) {
    print(error.toString());
  }
}

void makeNotificationForIshaPrayer(
    {required DateTime dateTime,
    required int hour,
    required int minute,
    required String timeZone,
    required AwesomeNotifications awesomeNotifications}) {
  try {
    awesomeNotifications.createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(10000),
          channelKey: channelKey,
          title: 'New Notification',
          body: 'This is a new notification example for fajr time.',
          displayOnForeground: true,
          displayOnBackground: true,
        ),
        schedule: NotificationCalendar(
          hour: hour,
          minute: minute,
          day: dateTime.day,
          second: 0,
          allowWhileIdle: true,
          timeZone: timeZone,
          preciseAlarm: true,
        ));
  } catch (error) {
    print(error.toString());
  }
}

void makeNotificationForSubhPrayer(
    {required DateTime dateTime,
    required int hour,
    required int minute,
    required String timeZone,
    required AwesomeNotifications awesomeNotifications}) {
  try {
    awesomeNotifications.createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(10000),
          channelKey: channelKey,
          title: 'New Notification',
          body: 'This is a new notification example for fajr time.',
          displayOnForeground: true,
          displayOnBackground: true,
        ),
        schedule: NotificationCalendar(
          hour: hour,
          minute: minute,
          day: dateTime.day,
          second: 0,
          allowWhileIdle: true,
          timeZone: timeZone,
          preciseAlarm: true,
        ));
  } catch (error) {
    print(error.toString());
  }
}

const String channelKey = 'phonetest';
