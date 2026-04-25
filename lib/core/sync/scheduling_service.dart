import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meditime/core/device/device_preferences.dart';
import 'package:meditime/core/storage/app_database.dart';
import 'package:meditime/features/medicines/data/medicine_scheduler.dart';
import 'package:meditime/features/medicines/domain/entities/medicine.dart';

class SchedulingService {
  SchedulingService._();
  static final instance = SchedulingService._();

  final _db = AppDatabase.instance;

  // Guards `scheduleWatchedIfStale` — re-running the full cancel+reschedule
  // cycle on every foreground blip is wasteful (each cycle hits native
  // notification + alarm APIs hundreds of times).
  DateTime? _lastScheduled;
  static const Duration _rescheduleCooldown = Duration(hours: 6);

  /// Schedule notifications for the profiles this device is watching.
  Future<void> scheduleWatched() async {
    final watched = await DevicePreferences.getWatchedProfileIds();
    final all = await _db.getAllMedicines();

    // Filter medicines whose profileId is in watched. If watched is empty,
    // pick the device default profile if present.
    List<Medicine> toSchedule = [];
    if (watched.isNotEmpty) {
      toSchedule = all.where((m) => watched.contains(m.profileId)).map(_toDomain).toList();
    } else {
      final def = await DevicePreferences.getDefaultProfileId();
      if (def != null) {
        toSchedule = all.where((m) => (m.profileId ?? '') == def).map(_toDomain).toList();
      }
    }

    await MedicineScheduler.cancelAll();
    if (toSchedule.isNotEmpty) {
      await MedicineScheduler.scheduleAll(toSchedule);
    }
    _lastScheduled = DateTime.now();
  }

  /// Roll the 7-day notification window forward when the user resumes the
  /// app, but only if we haven't already run in the cooldown window. Called
  /// from app lifecycle resume so late-reminders for "tomorrow" exist even
  /// when sync fails (offline). Idempotent; cheap no-op during cooldown.
  Future<void> scheduleWatchedIfStale() async {
    final last = _lastScheduled;
    if (last != null &&
        DateTime.now().difference(last) < _rescheduleCooldown) {
      return;
    }
    await scheduleWatched();
  }

  Medicine _toDomain(MedicineTableData t) {
    // Minimal conversion — times parsing may rely on JSON stored in reminderTimes
    List<TimeOfDay> times = [];
    try {
      if (t.reminderTimes != null && t.reminderTimes!.isNotEmpty) {
        final decoded = json.decode(t.reminderTimes!);
        if (decoded is List) {
          times = decoded.map<TimeOfDay>((e) {
            final hour = (e['hour'] as int?) ?? 0;
            final minute = (e['minute'] as int?) ?? 0;
            return TimeOfDay(hour: hour, minute: minute);
          }).toList();
        }
      }
    } catch (_) {}

    return Medicine(
      id: t.id,
      profileId: t.profileId,
      name: t.name,
      type: t.type,
      schedule: t.schedule,
      stockRemaining: t.stockRemaining,
      stockTotal: t.stockTotal,
      daysLeft: t.daysLeft,
      isLowStock: t.isLowStock,
      imagePath: t.imagePath,
      amount: t.amount,
      strength: t.strength,
      unit: t.unit,
      times: times,
    );
  }
}
