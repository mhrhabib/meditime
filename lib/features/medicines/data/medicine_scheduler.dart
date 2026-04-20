import 'package:flutter/foundation.dart';
import 'package:meditime/core/notifications/notification_service.dart';
import 'package:meditime/features/medicines/domain/entities/medicine.dart';

/// Converts a Medicine + its schedule string into real scheduled notifications.
/// Schedules one notification per dose per day for the next 14 days (rolling).
class MedicineScheduler {
  static const int _scheduleDays = 14;

  /// Unique notification ID from medicine ID + day + dose index.
  static int _notificationId(String medicineId, int dayOffset, int doseIndex) {
    return medicineId.hashCode ^ (dayOffset * 100 + doseIndex);
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
      }
    }

    debugPrint('[MedicineScheduler] Scheduled ${doseTimes.length * _scheduleDays} notifications for ${medicine.name}');
  }

  /// Cancel all notifications for a medicine.
  static Future<void> cancelForMedicine(Medicine medicine) async {
    final service = NotificationService.instance;
    final doseTimes = _parseDoseTimes(medicine.schedule);

    for (int day = 0; day < _scheduleDays; day++) {
      for (int doseIdx = 0; doseIdx < doseTimes.length; doseIdx++) {
        final notifId = _notificationId(medicine.id, day, doseIdx);
        await service.cancel(notifId);
      }
    }

    debugPrint('[MedicineScheduler] Cancelled notifications for ${medicine.name}');
  }

  /// Reschedule notifications for a medicine (cancel + re-schedule).
  static Future<void> rescheduleForMedicine(Medicine medicine) async {
    await cancelForMedicine(medicine);
    await scheduleForMedicine(medicine);
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
  }
}
