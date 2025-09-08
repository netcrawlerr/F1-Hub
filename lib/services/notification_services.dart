import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tl;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationServices {
  final notiticationPlugin = FlutterLocalNotificationsPlugin();

  final bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotificationService() async {
    if (_isInitialized) return;

    tl.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(android: androidSettings);

    await notiticationPlugin.initialize(settings);
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'F1 Hub',
        'F1 Hub Notifications',
        channelDescription: "Daily F1 Hub notifications",
        importance: Importance.max,
      ),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    await notiticationPlugin.show(id, title, body, notificationDetails());
  }

  Future<void> cancelNotification(int id) async {
    await notiticationPlugin.cancel(id);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required year,
    required month,
    required day,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(tz.local, year, month, day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      print("⚠️ Skipping past notification: $title at $scheduledDate");
      return;
    }

    await notiticationPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancelNotifications() async {
    await notiticationPlugin.cancelAll();
    print("#########");
    print("CANCELLED ALL NOTIFICATIONS");
  }
}
