import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract interface class INotificationClient {
  Future<void> initialize();
  Future<void> showNotification({
    required String title,
    required String body,
    int id = 0,
  });
}

class NotificationClient implements INotificationClient {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _budgetChannel = AndroidNotificationChannel(
    'budget_alerts',
    'Budget Alerts',
    description: 'Notifications for budget threshold breaches',
    importance: Importance.max,
  );

  @override
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings: initSettings);

    // Create Android channel
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_budgetChannel);
  }

  @override
  Future<void> showNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _budgetChannel.id,
      _budgetChannel.name,
      channelDescription: _budgetChannel.description,
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }
}
