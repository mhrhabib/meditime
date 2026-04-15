/// Pure function: predicts when a medication will run out.
class RefillPrediction {
  final int daysRemaining;
  final bool isUrgent;   // < 2 days
  final bool isWarning;  // < 5 days
  final String message;

  const RefillPrediction({
    required this.daysRemaining,
    required this.isUrgent,
    required this.isWarning,
    required this.message,
  });
}

class RefillPredictor {
  /// Compute refill prediction from current stock and doses per day.
  /// [dosesPerDay] is parsed from the schedule string (e.g. "3×" → 3).
  static RefillPrediction predict({
    required int currentStock,
    required int dosesPerDay,
  }) {
    if (dosesPerDay <= 0) {
      return const RefillPrediction(
        daysRemaining: 999,
        isUrgent: false,
        isWarning: false,
        message: 'No scheduled doses',
      );
    }

    final days = currentStock ~/ dosesPerDay;

    String message;
    if (days == 0) {
      message = 'Runs out today!';
    } else if (days == 1) {
      message = 'Runs out tomorrow';
    } else {
      message = 'Runs out in $days days';
    }

    return RefillPrediction(
      daysRemaining: days,
      isUrgent: days < 2,
      isWarning: days < 5,
      message: message,
    );
  }

  /// Parse dose count from schedule string like "Daily · 3× · After meal".
  static int parseDosesPerDay(String schedule) {
    final regex = RegExp(r'(\d+)×');
    final match = regex.firstMatch(schedule);
    return match != null ? int.tryParse(match.group(1)!) ?? 1 : 1;
  }
}
