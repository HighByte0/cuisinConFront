import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_delivery_flutter/controllers/auth_controller.dart';
import 'package:food_delivery_flutter/routes/route_helper.dart';
import 'package:get/get.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


Future<void> initializeNotifications() async {
  try {
    // Android Initialization Settings
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('notification_icon'); // Replace with your notification icon

    // iOS Initialization Settings
    const DarwinInitializationSettings iosInitializationSettings = DarwinInitializationSettings();

    // Initialization Settings
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings);

    // Initialize the FlutterLocalNotificationsPlugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          print('Notification payload: ${response.payload}');
          // Handle navigation or other logic here
        }
      },
      onDidReceiveBackgroundNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null && response.payload!.isNotEmpty) {
          print('Notification payload: ${response.payload}');
          // Handle navigation or other logic here
        }
      },
    );

    // Request iOS permissions
    final NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('iOS Permission status: ${settings.authorizationStatus}');

    // Set foreground notification presentation options
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received message while app is in foreground");
      print("Message title: ${message.notification?.title}");
      print("Message body: ${message.notification?.body}");

      // Show notification using local notifications plugin
      // HelperNotification.showNotification(message, flutterLocalNotificationsPlugin, false);

      // Example: If user is logged in, update relevant data
      if (Get.find<AuthController>().hasLogedIn()) {
        // Get.find<OrderController>().getRunningOrders(1);
        // Get.find<OrderController>().getHistoryOrders(1);
        // Get.find<NotificationController>().getNotificationList(true);
      }
    });

    // Handle background message taps
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification opened while app is in background");
      print("Message title: ${message.notification?.title}");
      print("Message body: ${message.notification?.body}");

      // Handle navigation or other logic here
    });

  } catch (e) {
    print('Error initializing notifications: ${e.toString()}');
  }
  void handleMessageOpenedApp(RemoteMessage message) {
  // Extract notification data
  String? notificationTitle = message.notification?.title;
  String? notificationBody = message.notification?.body;
  Map<String, dynamic> data = message.data;

  // Log notification details
  print('Notification opened while app is in background');
  print('Message title: $notificationTitle');
  print('Message body: $notificationBody');

  // Handle navigation or other logic based on notification data
  // Example: Navigate to a specific screen based on notification data
  if (data.containsKey('screen')) {
    String screen = data['screen'];
    switch (screen) {
      case 'order_details':
        String orderId = data['order_id'];
        Get.toNamed(RouteHelper.getInitial());
        break;
      case 'profile':
        Get.toNamed(RouteHelper.getInitial());
        break;
      default:
        Get.toNamed(RouteHelper.getInitial());
        break;
    }
  } else {
    Get.toNamed(RouteHelper.getInitial());
  }
}

}

