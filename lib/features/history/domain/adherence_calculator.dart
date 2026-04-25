import 'package:meditime/features/medicines/domain/entities/dose_event.dart';

/// Pure function: computes adherence stats from dose events.
class AdherenceResult {
  final double weeklyPercentage;
  final double previousWeekPercentage;
  final double delta;
  final int totalDoses;
  final int takenDoses;
  final int missedDoses;
  final int skippedDoses;

  const AdherenceResult({
    required this.weeklyPercentage,
    required this.previousWeekPercentage,
    required this.delta,
    required this.totalDoses,
    required this.takenDoses,
    required this.missedDoses,
    required this.skippedDoses,
  });

  String get summaryMessage {
    final pct = weeklyPercentage.round();
    if (delta > 0) {
      return 'You hit $pct% this week, up from ${previousWeekPercentage.round()}% 🎉';
    } else if (delta < 0) {
      return 'You hit $pct% this week, down from ${previousWeekPercentage.round()}%';
    } else {
      return 'You hit $pct% this week — same as last week';
    }
  }
}

class AdherenceCalculator {
  /// Compute adherence for a given week (defaults to current week).
  static AdherenceResult compute({
    required List<DoseEvent> events,
    DateTime? referenceDate,
  }) {
    final now = referenceDate ?? DateTime.now();

    // Current week: Mon-Sun containing `now`
    final currentWeekStart = _startOfWeek(now);
    final currentWeekEnd = currentWeekStart.add(const Duration(days: 7));

    // Previous week
    final prevWeekStart = currentWeekStart.subtract(const Duration(days: 7));

    final currentWeekEvents = events.where((e) =>
        e.scheduledTime.isAfter(currentWeekStart) &&
        e.scheduledTime.isBefore(currentWeekEnd));

    final prevWeekEvents = events.where((e) =>
        e.scheduledTime.isAfter(prevWeekStart) &&
        e.scheduledTime.isBefore(currentWeekStart));

    final currentPct = _percentage(currentWeekEvents);
    final prevPct = _percentage(prevWeekEvents);

    final taken = currentWeekEvents.where((e) => e.status == DoseEventStatus.taken).length;
    final missed = currentWeekEvents.where((e) => e.status == DoseEventStatus.missed).length;
    final skipped = currentWeekEvents.where((e) => e.status == DoseEventStatus.skipped).length;

    return AdherenceResult(
      weeklyPercentage: currentPct,
      previousWeekPercentage: prevPct,
      delta: currentPct - prevPct,
      totalDoses: currentWeekEvents.length,
      takenDoses: taken,
      missedDoses: missed,
      skippedDoses: skipped,
    );
  }

  static double _percentage(Iterable<DoseEvent> events) {
    if (events.isEmpty) return 0;
    final taken = events.where((e) => e.status == DoseEventStatus.taken).length;
    return (taken / events.length) * 100;
  }

  static DateTime _startOfWeek(DateTime date) {
    // Monday = 1
    final daysFromMon = date.weekday - 1;
    final monday = date.subtract(Duration(days: daysFromMon));
    return DateTime(monday.year, monday.month, monday.day);
  }
}
