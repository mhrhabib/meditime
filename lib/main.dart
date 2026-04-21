import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditime/app/app.dart';
import 'package:meditime/core/alarm/medicine_alarm_service.dart';
import 'package:meditime/core/notifications/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Notifications + Timezones
  await NotificationService.instance.initialize();
  await MedicineAlarmService.instance.initialize();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MediTimeApp());
}
