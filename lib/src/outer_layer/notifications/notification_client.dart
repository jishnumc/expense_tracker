import 'dart:io';
import 'package:expense_tracker/src/app_ui/widgets/notifications/et_notification_banner.dart';
import 'package:expense_tracker/src/router/app_router.dart';
import 'package:expense_tracker/src/system/utils/logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract interface class INotificationClient {
  Future<void> initialize();
  Future<void> requestPermissions();
  Future<void> showNotification({
    required String title,
    required String body,
    int id = 0,
  });
}

class NotificationClient implements INotificationClient {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _budgetChannel =
      AndroidNotificationChannel(
        'budget_alerts',
        'Budget Alerts',
        description: 'Notifications for budget threshold breaches',
        importance: Importance.max,
      );

  @override
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings: initSettings);

    // Create Android channel
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_budgetChannel);
  }

  @override
  Future<void> requestPermissions() async {
    // Request Permissions
    if (Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  @override
  Future<void> showNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    // 1. Show custom In-App Notification Banner if the app is in the foreground
    final navigatorState = AppRouter.navigatorKey.currentState;
    if (navigatorState != null && navigatorState.mounted) {
      try {
        final overlay = navigatorState.overlay;
        if (overlay != null) {
          ETNotificationBanner.showOverlay(overlay, title: title, body: body);
          return; // Skip the OS notification to prevent double-banners while in app
        }
      } catch (e, stackTrace) {
        talker.error('Foreground Banner Error', e, stackTrace);
      }
    }

    final androidDetails = AndroidNotificationDetails(
      _budgetChannel.id,
      _budgetChannel.name,
      channelDescription: _budgetChannel.description,
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
      );
    } catch (e, stackTrace) {
      talker.error('NOTIFICATION ERROR', e, stackTrace);
    }
  }
}
