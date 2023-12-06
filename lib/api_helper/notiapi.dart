import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Noti {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin()
        ..resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();

  static const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');

  // 안드로이드 플랫폼에서 사용할 초기화 설정
  final InitializationSettings initializationSettings =
      const InitializationSettings(
    android: initializationSettingsAndroid,
  );

  static const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'counter_channel',
    'Counter Channel',
    channelDescription:
        'This channel is used for counter-related notifications',
    // 알림 채널 설명
    icon: '@drawable/ic_launcher',
    importance: Importance.high, // 알림 중요도
    priority: Priority.high,
    ongoing: true,
  );

  static Future initializeNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> schedulNotification(
    String title,
    content,
    DateTime datetime,
    int notificationId,
  ) async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        datetime.year,
        datetime.month,
        datetime.day,
        datetime.hour,
        datetime.minute,
        datetime.second);
    // 알림 채널 설정값 구성
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'counter_channel', // 알림 채널 ID
            'Counter Channel', // 알림 채널 이름
            channelDescription:
                'This channel is used for counter-related notifications',
            // 알림 채널 설명
            icon: '@drawable/ic_launcher',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');
    // 알림 상세 정보 설정
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    // 알림 보이기
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      '설정 날짜 : $content',
      scheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
