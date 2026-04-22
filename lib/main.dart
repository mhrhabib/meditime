import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditime/app/app.dart';
import 'package:meditime/core/alarm/medicine_alarm_service.dart';
import 'package:meditime/core/config/supabase_config.dart';
import 'package:meditime/core/device/device_identity.dart';
import 'package:meditime/core/notifications/notification_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Supabase ─────────────────────────────────────────────────────
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  // ── Device identity (initialise once so cachedId is always ready) ─
  await DeviceIdentity.id;

  // ── Notifications + Alarms ────────────────────────────────────────
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
