import 'package:adhan_dart/adhan_dart.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'constance.dart';

class NotificationHandelr {
  AwesomeNotifications awesomeNotifications = AwesomeNotifications();
  DateTime now = DateTime.now();

  Future<void> scheduleNotifications(
      {required List<PrayerTimes> prayersTimesList}) async {
    String localTimeZone =
        await awesomeNotifications.getLocalTimeZoneIdentifier();
    awesomeNotifications.cancelAll();
    for (int i = 0; i < prayersTimesList.length; i++) {
      DateTime scheduleDate = now.add(Duration(days: i));
      makeNotificationForFajrPrayer(
        minute: prayersTimesList[i].fajr!.toLocal().minute,
        hour: prayersTimesList[i].fajr!.toLocal().hour,
        timeZone: localTimeZone,
        dateTime: scheduleDate,
        awesomeNotifications: awesomeNotifications,
      );
      makeNotificationForDuhurPrayer(
          dateTime: scheduleDate,
          hour: prayersTimesList[i].dhuhr!.toLocal().hour,
          minute: prayersTimesList[i].dhuhr!.toLocal().minute,
          timeZone: localTimeZone,
          awesomeNotifications: awesomeNotifications);

      makeNotificationForAsrPrayer(
          dateTime: scheduleDate,
          hour: prayersTimesList[i].asr!.toLocal().hour,
          minute: prayersTimesList[i].asr!.toLocal().minute,
          timeZone: localTimeZone,
          awesomeNotifications: awesomeNotifications);

      makeNotificationForMaghribPrayer(
          dateTime: scheduleDate,
          hour: prayersTimesList[i].maghrib!.toLocal().hour,
          minute: prayersTimesList[i].maghrib!.toLocal().minute,
          timeZone: localTimeZone,
          awesomeNotifications: awesomeNotifications);

      makeNotificationForIshaPrayer(
          dateTime: scheduleDate,
          hour: prayersTimesList[i].isha!.toLocal().hour,
          minute: prayersTimesList[i].isha!.toLocal().minute,
          timeZone: localTimeZone,
          awesomeNotifications: awesomeNotifications);
      makeNotificationForSubhPrayer(
          dateTime: scheduleDate,
          hour:prayersTimesList[i].sunrise!.toLocal().hour,
          minute: prayersTimesList[i].sunrise!.toLocal().minute,
          timeZone: localTimeZone,
          awesomeNotifications: awesomeNotifications);
    }
  }
}
