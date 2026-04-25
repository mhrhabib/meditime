import 'package:flutter/foundation.dart';
import 'package:meditime/core/alarm/medicine_alarm_service.dart';
import 'package:meditime/core/notifications/notification_service.dart';
import 'package:meditime/features/medicines/domain/entities/medicine.dart';

/// Converts a Medicine + its schedule string into real scheduled notifications.
/// Schedules one notification per dose per day for the next 14 days (rolling).
class MedicineScheduler {
  // 7-day rolling window (was 14). Pending notifications on Android cap at
  // 500 and on iOS at 64 — with late-reminders we now schedule up to 2× per
  // dose, so shrinking the horizon keeps even power users under the iOS cap.
  static const int _scheduleDays = 7;
  // How long after a scheduled slot we fire a "still need to take X?" reminder
  // if the user hasn't responded. Mirrors `_missedGrace` on the home screen.
  static const Duration _lateGrace = Duration(minutes: 30);
  // Only schedule late reminders for today + tomorrow — anything further out
  // will be rescheduled on next app-open before the grace window matters,
  // and keeps the pending-notification count bounded.
  static const int _lateReminderHorizonDays = 2;

  /// Unique notification ID from medicine ID + day + dose index.
  static int _notificationId(String medicineId, int dayOffset, int doseIndex) {
    return medicineId.hashCode ^ (dayOffset * 100 + doseIndex);
  }

  /// ID for the paired "late dose" reminder that fires after the grace window.
  /// Must be deterministic so we can cancel it when the primary dose is handled.
  static int _lateNotificationId(
      String medicineId, int dayOffset, int doseIndex) {
    // XOR a sentinel into the bottom bits so it can never collide with the
    // primary notification ID.
    return (_notificationId(medicineId, dayOffset, doseIndex)) ^ 0x5A5A5A;
  }

  static String _fmt(DateTime t) {
    final h = t.hour > 12 ? t.hour - 12 : (t.hour == 0 ? 12 : t.hour);
    final m = t.minute.toString().padLeft(2, '0');
    final ampm = t.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  /// Parse dose times from a schedule string like "Daily · 3× · After meal".
  /// Returns a list of default times based on the dose count.
  static List<Duration> _parseDoseTimes(String schedule) {
    // Extract dose count from schedule (e.g. "3×" → 3)
    final regex = RegExp(r'(\d+)×');
    final match = regex.firstMatch(schedule);
    final count = match != null ? int.tryParse(match.group(1)!) ?? 1 : 1;

    // Default times based on count
    switch (count) {
      case 1:
        return [const Duration(hours: 8)]; // 8:00 AM
      case 2:
        return [
          const Duration(hours: 8),  // 8:00 AM
          const Duration(hours: 20), // 8:00 PM
        ];
      case 3:
        return [
          const Duration(hours: 8),  // 8:00 AM
          const Duration(hours: 14), // 2:00 PM
          const Duration(hours: 20), // 8:00 PM
        ];
      case 4:
        return [
          const Duration(hours: 7),  // 7:00 AM
          const Duration(hours: 12), // 12:00 PM
          const Duration(hours: 17), // 5:00 PM
          const Duration(hours: 22), // 10:00 PM
        ];
      default:
        // Spread evenly from 8 AM
        return List.generate(count, (i) {
          final hoursSpread = 14 ~/ count; // Spread over 14 waking hours
          return Duration(hours: 8 + i * hoursSpread);
        });
    }
  }

  /// Public helper: returns concrete dose times (as Durations since midnight)
  /// for a given `Medicine` taking into account `times` (if present) or
  /// falling back to schedule defaults.
  static List<Duration> doseTimesForMedicine(Medicine medicine) {
    if (medicine.times.isNotEmpty) {
      return medicine.times
          .map((t) => Duration(hours: t.hour, minutes: t.minute))
          .toList();
    }
    return _parseDoseTimes(medicine.schedule);
  }

  /// Schedule notifications for a single medicine for the next 14 days.
  static Future<void> scheduleForMedicine(Medicine medicine) async {
    final service = NotificationService.instance;
    final doseTimes = medicine.times.isNotEmpty
        ? medicine.times
            .map((t) => Duration(hours: t.hour, minutes: t.minute))
            .toList()
        : _parseDoseTimes(medicine.schedule);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (int day = 0; day < _scheduleDays; day++) {
      final date = today.add(Duration(days: day));

      // ── Filter by Active Window ──
      final daysSinceStart = date.difference(medicine.startDate).inDays;
      if (daysSinceStart < 0) continue; // Not started yet
      if (medicine.durationDays != -1 && daysSinceStart >= medicine.durationDays) {
        continue; // Course finished
      }

      for (int doseIdx = 0; doseIdx < doseTimes.length; doseIdx++) {
        final scheduledTime = date.add(doseTimes[doseIdx]);

        // Skip if in the past
        if (scheduledTime.isBefore(now)) continue;

        final notifId = _notificationId(medicine.id, day, doseIdx);

        await service.scheduleNotification(
          id: notifId,
          title: '💊 Time for ${medicine.name}',
          body: 'Dose ${doseIdx + 1} of ${doseTimes.length} · ${medicine.schedule}',
          scheduledTime: scheduledTime,
          payload: '${medicine.id}|$doseIdx|${scheduledTime.toIso8601String()}',
          critical: medicine.isLowStock, // Critical if running low
        );

        // Fire a loud, looping alarm at the same moment. Elderly users often
        // miss silent notifications — the alarm keeps ringing until they
        // tap Stop or the cubit cancels it after a dose action.
        await MedicineAlarmService.instance.scheduleForDose(
          id: notifId,
          fireAt: scheduledTime,
          medicineName: medicine.name,
          body:
              'Dose ${doseIdx + 1} of ${doseTimes.length} · ${medicine.schedule}',
        );

        // "Late dose" check-in — fires `_lateGrace` after the scheduled time
        // unless the user has taken/skipped/snoozed the dose (cancelDose /
        // cancelForMedicine removes it first).
        //
        // Throttled to avoid blowing past iOS's 64-notification cap:
        //   - only today + tomorrow (further days re-schedule on app-open)
        //   - skipped for low-stock/critical medicines (the primary is already
        //     loud + non-dismissible and a late follow-up adds noise)
        final lateFire = scheduledTime.add(_lateGrace);
        final withinHorizon = day < _lateReminderHorizonDays;
        if (lateFire.isAfter(now) && withinHorizon && !medicine.isLowStock) {
          await service.scheduleNotification(
            id: _lateNotificationId(medicine.id, day, doseIdx),
            title: '⏰ Still need your ${medicine.name}?',
            body:
                'It was due at ${_fmt(scheduledTime)}. Tap to log it now.',
            scheduledTime: lateFire,
            payload:
                '${medicine.id}|$doseIdx|${scheduledTime.toIso8601String()}',
          );
        }
      }
    }

    debugPrint('[MedicineScheduler] Scheduled ${doseTimes.length * _scheduleDays} notifications + alarms for ${medicine.name}');
  }

  /// Cancel all notifications for a medicine.
  static Future<void> cancelForMedicine(Medicine medicine) async {
    final service = NotificationService.instance;
    final alarm = MedicineAlarmService.instance;
    final doseTimes = _parseDoseTimes(medicine.schedule);

    for (int day = 0; day < _scheduleDays; day++) {
      for (int doseIdx = 0; doseIdx < doseTimes.length; doseIdx++) {
        final notifId = _notificationId(medicine.id, day, doseIdx);
        await service.cancel(notifId);
        await service.cancel(_lateNotificationId(medicine.id, day, doseIdx));
        await alarm.cancel(notifId);
      }
    }

    debugPrint('[MedicineScheduler] Cancelled notifications + alarms for ${medicine.name}');
  }

  /// Reschedule notifications for a medicine (cancel + re-schedule).
  static Future<void> rescheduleForMedicine(Medicine medicine) async {
    await cancelForMedicine(medicine);
    await scheduleForMedicine(medicine);
  }

  /// Stop the ringing alarm (and dismiss the paired notification) for a
  /// single dose once the user has taken / skipped / snoozed it. Called
  /// from the cubit and from notification action handlers.
  static Future<void> cancelDose({
    required String medicineId,
    required int doseIdx,
    required DateTime scheduledTime,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scheduledDate =
        DateTime(scheduledTime.year, scheduledTime.month, scheduledTime.day);
    final dayOffset = scheduledDate.difference(today).inDays;

    final notifId = _notificationId(medicineId, dayOffset, doseIdx);
    await NotificationService.instance.cancel(notifId);
    await NotificationService.instance
        .cancel(_lateNotificationId(medicineId, dayOffset, doseIdx));
    await MedicineAlarmService.instance.cancel(notifId);
  }

  /// Schedule notifications for all medicines.
  static Future<void> scheduleAll(List<Medicine> medicines) async {
    for (final med in medicines) {
      await scheduleForMedicine(med);
    }
  }

  /// Cancel all medicine notifications.
  static Future<void> cancelAll() async {
    await NotificationService.instance.cancelAll();
    await MedicineAlarmService.instance.cancelAll();
  }
}
