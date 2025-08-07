import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:varosa_multi_app/utils/logger.dart';
import '../models/todo.dart';
import '../../../../../core/services/firebase/firebase_notification/fcm_notification_service.dart';

class TodoNotificationService {
  static final TodoNotificationService _instance =
      TodoNotificationService._internal();

  factory TodoNotificationService() => _instance;

  TodoNotificationService._internal();

  // Using shared FCM notification plugin instance

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone data
    tz_data.initializeTimeZones();

    // Set the local timezone
    // It can be dynamic based on the user's location
    // but for the sake of simplicity, I'm using Kathmandu
    tz.setLocalLocation(tz.getLocation('Asia/Kathmandu'));

    // Use the FCM notification service setup
    await setupFlutterLocalNotifications(
      onDidReceiveNotificationResponse: (response) {
        // Handle notification response here
        // You can navigate to a specific screen or perform any other action
        // based on the notification's payload
      },
      onDidReceiveBackgroundNotificationResponse: (response) {
        // Handle background notification response here
      },
    );

    _isInitialized = true;
  }

  Future<void> requestPermissions() async {
    if (!_isInitialized) await initialize();

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidPlugin?.requestExactAlarmsPermission();

    final IOSFlutterLocalNotificationsPlugin? iosPlugin =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();

    await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> scheduleTodoNotification(Todo todo) async {
    if (!_isInitialized) await initialize();

    // Request permissions for notifications
    await requestPermissions();

    // Cancel any existing notification for this todo
    if (todo.id != null) {
      await cancelNotification(todo.id!);
    }

    // Only schedule if the todo has a due date and is not completed
    if (todo.dueDate == null || todo.isCompleted) return;

    // Don't schedule if the due date is in the past
    final now = DateTime.now();
    if (todo.dueDate!.isBefore(now)) return;

    final todoId = todo.id ?? 0;
    final title = todo.title ?? 'Todo Reminder';
    final body = todo.description ?? 'Your todo is due now';

    Logger.logMessage(tz.local.name);
    Logger.logMessage(tz.local.currentTimeZone.abbreviation);

    // Use the FCM service's scheduled notification method
    await showScheduledNotification(
      id: todoId,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(todo.dueDate!, tz.local),
      payload: todoId.toString(),
    );
  }

  /// Cancel a specific notification by to-do item ID
  ///
  Future<void> cancelNotification(int id) async {
    if (!_isInitialized) await initialize();
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Cancel all notifications
  ///
  Future<void> cancelAllNotifications() async {
    if (!_isInitialized) await initialize();
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
