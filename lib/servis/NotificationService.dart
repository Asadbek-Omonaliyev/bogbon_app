import 'package:bogbon/main.dart';
import 'package:bogbon/servis/provider/CareProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Tashkent'));
    } catch (e) {
      debugPrint('Timezone xatosi: $e');
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _showWateringDialog(response.payload!);
        }
      },
    );

    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      final bool? canSchedule =
      await androidPlugin.canScheduleExactNotifications();
      if (canSchedule != true) {
        await androidPlugin.requestExactAlarmsPermission();
      }
    }
  }

  static void _showWateringDialog(String payload) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    // Payload format: "ID|NAME"
    final parts = payload.split('|');
    if (parts.length < 2) return;
    
    final int plantId = int.tryParse(parts[0]) ?? 0;
    final String plantName = parts[1];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("$plantName sug'orish", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.water_drop, size: 60, color: Colors.blue),
            const SizedBox(height: 20),
            Text("Hozir $plantName o'simligini sug'ordingizmi?"),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              final careProvider = Provider.of<CareProvider>(context, listen: false);
              careProvider.addPostponedPlant(payload); // "ID|NAME" saqlanadi

              // 3 soatdan keyin yana eslatish
              schedulePlantReminder(
                id: plantId,
                plantName: plantName,
                days: 0,
                hoursLater: 3,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Keyinroq sug'orish belgilandi (-5 XP). 3 soatdan so'ng yana eslatamiz."),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text("Keyinroq", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              final careProvider = Provider.of<CareProvider>(context, listen: false);
              careProvider.incrementWateringCount();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Ajoyib! O'simlik sug'orildi"), backgroundColor: Colors.green),
              );
            },
            child: const Text("Sug'ordim"),
          ),
        ],
      ),
    );
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    debugPrint("NotificationService: Bildirishnoma chiqarilmoqda - $title");
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'plant_reminders_v4',
      'O\'simliklar parvarishi',
      channelDescription: 'O\'simliklarni sug\'orish haqida eslatmalar',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      color: Color(0xFF2D7D32),
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(android: androidDetails),
      payload: payload,
    );
  }

  static Future<void> schedulePlantReminder({
    required int id,
    required String plantName,
    required int days,
    int hoursLater = 0,
  }) async {
    final bool isTest = (id == 1 || id == 2) && hoursLater == 0;

    tz.TZDateTime scheduledDate;
    if (hoursLater > 0) {
      scheduledDate = tz.TZDateTime.now(tz.local).add(Duration(hours: hoursLater));
    } else {
      scheduledDate = tz.TZDateTime.now(tz.local).add(
        isTest ? const Duration(seconds: 10) : Duration(days: days),
      );
    }

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'plant_reminders_v4',
      'O\'simliklar parvarishi',
      channelDescription: 'O\'simliklarni sug\'orish haqida eslatmalar',
      importance: Importance.max,
      priority: Priority.high,
      color: const Color(0xFF2D7D32),
      styleInformation: BigTextStyleInformation(
        "Bugun $plantName o'simligingiz uchun sug'orish vaqti keldi. Uni parvarish qilishni unutmang! 💧",
        contentTitle: "Sug'orish vaqti keldi! 💧",
      ),
    );

    await _notificationsPlugin.zonedSchedule(
      id * 10,
      "Sug'orish vaqti! 💧",
      "Bugun $plantName o'simligingizni sug'orishingiz kerak.",
      scheduledDate,
      NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: hoursLater > 0 ? null : DateTimeComponents.time,
      payload: "$id|$plantName",
    );
  }

  static Future<void> cancelReminder(int id) async {
    await _notificationsPlugin.cancel(id * 10);
  }

  static Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
