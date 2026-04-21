import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:flutter/foundation.dart';

/// Loud, persistent medication alarms for elderly users who may miss a
/// standard notification. Rings until the user taps Stop (or the app
/// cancels the alarm after a dose is taken/skipped/snoozed).
///
/// The alarm package fires its own foreground notification with a Stop
/// button. We also keep the flutter_local_notifications reminder active
/// at the same moment so the user still sees Take / Snooze / Skip
/// actions alongside the ring.
class MedicineAlarmService {
  MedicineAlarmService._();
  static final MedicineAlarmService instance = MedicineAlarmService._();

  /// Available alarm tones bundled under assets/sounds/. The first entry is
  /// the default used when no per-medicine override is set. Expose the list
  /// if you want a picker in settings later.
  static const String defaultTone =
      'assets/sounds/mixkit-classic-alarm-995.wav';

  static const List<String> availableTones = [
    'assets/sounds/mixkit-classic-alarm-995.wav',
    'assets/sounds/mixkit-alarm-tone-996.wav',
    'assets/sounds/mixkit-alert-alarm-1005.wav',
    'assets/sounds/mixkit-classic-winner-alarm-1997.wav',
    'assets/sounds/mixkit-digital-clock-digital-alarm-buzzer-992.wav',
    'assets/sounds/mixkit-emergency-alert-alarm-1007.wav',
    'assets/sounds/mixkit-morning-clock-alarm-1003.wav',
    'assets/sounds/mixkit-retro-game-emergency-alarm-1000.wav',
    'assets/sounds/mixkit-rooster-crowing-in-the-morning-2462.wav',
  ];

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    await Alarm.init();
    _initialized = true;
    debugPrint('[MedicineAlarmService] initialized');
  }

  /// Schedule (or replace) a medicine alarm.
  ///
  /// [id] must be stable across schedule/cancel calls for the same dose so
  /// that rescheduling overwrites cleanly. Use the same ID you use for the
  /// flutter_local_notifications entry for this dose.
  Future<void> scheduleForDose({
    required int id,
    required DateTime fireAt,
    required String medicineName,
    required String body,
    String? tonePath,
  }) async {
    if (!_initialized) await initialize();
    if (fireAt.isBefore(DateTime.now())) return;

    final settings = AlarmSettings(
      id: _clampId(id),
      dateTime: fireAt,
      assetAudioPath: tonePath ?? defaultTone,
      loopAudio: true,
      vibrate: true,
      warningNotificationOnKill: Platform.isIOS,
      androidFullScreenIntent: true,
      volumeSettings: const VolumeSettings.fixed(
        volume: 0.9,
        volumeEnforced: true,
      ),
      notificationSettings: NotificationSettings(
        title: '💊 Time for $medicineName',
        body: body,
        stopButton: 'Stop alarm',
        // icon omitted — no notification_icon drawable in res/drawable.
        // The alarm plugin falls back to the app's launcher icon, which
        // is what we want here anyway.
      ),
    );

    await Alarm.set(alarmSettings: settings);
  }

  Future<void> cancel(int id) async {
    if (!_initialized) return;
    await Alarm.stop(_clampId(id));
  }

  Future<void> cancelAll() async {
    if (!_initialized) return;
    await Alarm.stopAll();
  }

  /// Alarm package IDs must fit in a positive 32-bit int. The notification
  /// scheduler mints IDs via XOR of a string hash, which can be negative or
  /// exceed int32 — clamp before handing the value to the alarm plugin.
  int _clampId(int id) => id & 0x7FFFFFFF;
}
